import 'dart:math';

class YoloDecoder {
  final List<String> labels;
  final double confThreshold;
  final double iouThreshold;
  final int numClasses;

  YoloDecoder({
    required this.labels,
    this.confThreshold = 0.25,
    this.iouThreshold = 0.45,
  }) : numClasses = labels.length;

  /// Decode raw model output
  /// Output shape is expected to be [1, 4 + numClasses, numBoxes]
  /// or [1, numBoxes, 4 + numClasses] depending on model export.
  /// YOLOv8 default export is usually [1, 4+nc, 8400].
  List<Map<String, dynamic>> decode(List<dynamic> rawOutput, int inputWidth, int inputHeight) {
    // 假设 rawOutput 是 [1, channels, anchors] 的多维数组
    // 或者扁平化列表。tflite_flutter 通常返回多维列表。
    
    // Check shape
    // rawOutput[0] is the batch.
    List<dynamic> batch0 = rawOutput[0]; 
    
    // We need to determine if it's [4+nc, anchors] or [anchors, 4+nc]
    // Usually YOLOv8 is [channels, anchors] e.g. [84, 8400]
    int dim1 = batch0.length;
    int dim2 = batch0[0].length;
    
    int channels = 0;
    int anchors = 0;
    bool isChannelFirst = true;

    if (dim1 == (4 + numClasses)) {
      channels = dim1;
      anchors = dim2;
      isChannelFirst = true;
    } else if (dim2 == (4 + numClasses)) {
      anchors = dim1;
      channels = dim2;
      isChannelFirst = false;
    } else {
      // Fallback/Error guess
      print('[YoloDecoder] Warning: Output shape [$dim1, $dim2] does not match classes ($numClasses) + 4.');
      // Attempt to guess: smaller dim is likely channels
      if (dim1 < dim2) {
         channels = dim1;
         anchors = dim2;
         isChannelFirst = true;
      } else {
        anchors = dim1;
         channels = dim2;
         isChannelFirst = false;
      }
    }
    
    List<List<double>> candidates = [];

    // Iterate over anchors
    for (int i = 0; i < anchors; i++) {
      // Extract class scores
      double maxScore = 0;
      int bestClassIndex = -1;
      
      // Class scores start at index 4
      for (int c = 0; c < numClasses; c++) {
        double score;
        if (isChannelFirst) {
          score = batch0[4 + c][i] as double; 
        } else {
          score = batch0[i][4 + c] as double;
        }
        
        if (score > maxScore) {
          maxScore = score;
          bestClassIndex = c;
        }
      }

      if (maxScore > confThreshold) {
        // Parse Box (cx, cy, w, h)
        // normalized relative to model input usually? Or pixel absolute? 
        // YOLOv8 TFLite export is usually absolute pixels (0-640).
        double cx, cy, w, h;
        
        if (isChannelFirst) {
          cx = batch0[0][i];
          cy = batch0[1][i];
          w  = batch0[2][i];
          h  = batch0[3][i];
        } else {
          cx = batch0[i][0];
          cy = batch0[i][1];
          w  = batch0[i][2];
          h  = batch0[i][3];
        }

        double x1 = cx - w / 2;
        double y1 = cy - h / 2;
        double x2 = cx + w / 2;
        double y2 = cy + h / 2;
        
        candidates.add([x1, y1, x2, y2, maxScore, bestClassIndex.toDouble()]);
      }
    }

    // Apply NMS
    return _nms(candidates);
  }

  List<Map<String, dynamic>> _nms(List<List<double>> boxes) {
    // Sort by confidence (descending)
    boxes.sort((a, b) => b[4].compareTo(a[4]));

    List<Map<String, dynamic>> results = [];
    List<bool> suppressed = List.filled(boxes.length, false);

    for (int i = 0; i < boxes.length; i++) {
      if (suppressed[i]) continue;
      
      final boxA = boxes[i];
      results.add({
        'box': [boxA[0], boxA[1], boxA[2], boxA[3], boxA[4]], // x1,y1,x2,y2,conf
        'tag': labels[boxA[5].toInt()],
      });

      for (int j = i + 1; j < boxes.length; j++) {
        if (suppressed[j]) continue;
        
        final boxB = boxes[j];
        double iou = _calculateIoU(boxA, boxB);
        if (iou > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }
    return results;
  }

  double _calculateIoU(List<double> boxA, List<double> boxB) {
    double xA = max(boxA[0], boxB[0]);
    double yA = max(boxA[1], boxB[1]);
    double xB = min(boxA[2], boxB[2]);
    double yB = min(boxA[3], boxB[3]);

    double interArea = max(0, xB - xA) * max(0, yB - yA);
    double boxAArea = (boxA[2] - boxA[0]) * (boxA[3] - boxA[1]);
    double boxBArea = (boxB[2] - boxB[0]) * (boxB[3] - boxB[1]);

    return interArea / (boxAArea + boxBArea - interArea);
  }
}

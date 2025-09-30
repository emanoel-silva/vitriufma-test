import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service to manage focus order and traversal throughout the app
class FocusManagementService {
  static final FocusManagementService _instance = FocusManagementService._internal();
  factory FocusManagementService() => _instance;
  FocusManagementService._internal();

  // Focus management
  final Map<String, List<FocusNode>> _pagesFocusNodes = {};
  final Map<String, int> _currentFocusIndex = {};
  String? _currentPage;

  /// Initialize focus management for a page
  void initializePage(String pageKey) {
    _currentPage = pageKey;
    if (!_pagesFocusNodes.containsKey(pageKey)) {
      _pagesFocusNodes[pageKey] = [];
      _currentFocusIndex[pageKey] = -1;
    }
  }

  /// Register focus nodes for a page in order
  void registerPageFocusNodes(String pageKey, List<FocusNode> focusNodes) {
    _pagesFocusNodes[pageKey] = focusNodes;
    _currentFocusIndex[pageKey] = -1;
    
    // Setup focus traversal order
    for (int i = 0; i < focusNodes.length; i++) {
      final node = focusNodes[i];
      node.addListener(() {
        if (node.hasFocus) {
          _currentFocusIndex[pageKey] = i;
        }
      });
    }
  }

  /// Add a focus node to the current page
  void addFocusNode(String pageKey, FocusNode focusNode, {int? index}) {
    if (!_pagesFocusNodes.containsKey(pageKey)) {
      _pagesFocusNodes[pageKey] = [];
      _currentFocusIndex[pageKey] = -1;
    }

    if (index != null) {
      _pagesFocusNodes[pageKey]!.insert(index, focusNode);
    } else {
      _pagesFocusNodes[pageKey]!.add(focusNode);
    }

    // Add listener to track focus changes
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _currentFocusIndex[pageKey] = _pagesFocusNodes[pageKey]!.indexOf(focusNode);
      }
    });
  }

  /// Remove a focus node from a page
  void removeFocusNode(String pageKey, FocusNode focusNode) {
    _pagesFocusNodes[pageKey]?.remove(focusNode);
  }

  /// Focus on the next element
  void focusNext({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    if (key == null) return;

    final nodes = _pagesFocusNodes[key];
    if (nodes == null || nodes.isEmpty) return;

    final currentIndex = _currentFocusIndex[key] ?? -1;
    final nextIndex = (currentIndex + 1) % nodes.length;
    
    nodes[nextIndex].requestFocus();
    _currentFocusIndex[key] = nextIndex;
  }

  /// Focus on the previous element
  void focusPrevious({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    if (key == null) return;

    final nodes = _pagesFocusNodes[key];
    if (nodes == null || nodes.isEmpty) return;

    final currentIndex = _currentFocusIndex[key] ?? 0;
    final previousIndex = currentIndex <= 0 ? nodes.length - 1 : currentIndex - 1;
    
    nodes[previousIndex].requestFocus();
    _currentFocusIndex[key] = previousIndex;
  }

  /// Focus on the first element of a page
  void focusFirst({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    if (key == null) return;

    final nodes = _pagesFocusNodes[key];
    if (nodes != null && nodes.isNotEmpty) {
      nodes.first.requestFocus();
      _currentFocusIndex[key] = 0;
    }
  }

  /// Focus on the last element of a page
  void focusLast({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    if (key == null) return;

    final nodes = _pagesFocusNodes[key];
    if (nodes != null && nodes.isNotEmpty) {
      nodes.last.requestFocus();
      _currentFocusIndex[key] = nodes.length - 1;
    }
  }

  /// Focus on a specific element by index
  void focusAt(int index, {String? pageKey}) {
    final key = pageKey ?? _currentPage;
    if (key == null) return;

    final nodes = _pagesFocusNodes[key];
    if (nodes != null && index >= 0 && index < nodes.length) {
      nodes[index].requestFocus();
      _currentFocusIndex[key] = index;
    }
  }

  /// Get current focused index for a page
  int getCurrentFocusIndex({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    return _currentFocusIndex[key] ?? -1;
  }

  /// Get total focus nodes count for a page
  int getFocusNodeCount({String? pageKey}) {
    final key = pageKey ?? _currentPage;
    return _pagesFocusNodes[key]?.length ?? 0;
  }

  /// Clear focus for a page
  void clearPageFocus(String pageKey) {
    final nodes = _pagesFocusNodes[pageKey];
    if (nodes != null) {
      for (final node in nodes) {
        node.unfocus();
      }
      _currentFocusIndex[pageKey] = -1;
    }
  }

  /// Dispose resources for a page
  void disposePage(String pageKey) {
    clearPageFocus(pageKey);
    _pagesFocusNodes.remove(pageKey);
    _currentFocusIndex.remove(pageKey);
    
    if (_currentPage == pageKey) {
      _currentPage = null;
    }
  }

  /// Create a custom focus traversal policy
  FocusTraversalPolicy createTraversalPolicy(String pageKey) {
    return CustomFocusTraversalPolicy(
      focusNodes: _pagesFocusNodes[pageKey] ?? [],
    );
  }

  /// Get all focus nodes for a page
  List<FocusNode>? getPageFocusNodes(String pageKey) {
    return _pagesFocusNodes[pageKey];
  }

  /// Set current page
  void setCurrentPage(String pageKey) {
    _currentPage = pageKey;
  }

  /// Get current page
  String? get currentPage => _currentPage;
}

/// Custom focus traversal policy for ordered navigation
class CustomFocusTraversalPolicy extends FocusTraversalPolicy {
  final List<FocusNode> focusNodes;

  CustomFocusTraversalPolicy({required this.focusNodes});

  @override
  FocusNode? findFirstFocus(FocusNode currentNode, {bool ignoreCurrentFocus = false}) {
    return focusNodes.isNotEmpty ? focusNodes.first : null;
  }

  @override
  FocusNode findLastFocus(FocusNode currentNode, {bool ignoreCurrentFocus = false}) {
    return focusNodes.isNotEmpty ? focusNodes.last : FocusNode();
  }

  @override
  FocusNode? findFirstFocusInDirection(FocusNode currentNode, TraversalDirection direction) {
    switch (direction) {
      case TraversalDirection.up:
        return findFirstFocus(currentNode);
      case TraversalDirection.down:
        return findLastFocus(currentNode);
      case TraversalDirection.left:
        return findFirstFocus(currentNode);
      case TraversalDirection.right:
        return findLastFocus(currentNode);
    }
  }

  @override
  FocusNode? findNextFocus(FocusNode currentNode, {FocusTraversalPolicy? policy}) {
    final currentIndex = focusNodes.indexOf(currentNode);
    if (currentIndex >= 0 && currentIndex < focusNodes.length - 1) {
      return focusNodes[currentIndex + 1];
    }
    return null;
  }

  @override
  FocusNode? findPreviousFocus(FocusNode currentNode, {FocusTraversalPolicy? policy}) {
    final currentIndex = focusNodes.indexOf(currentNode);
    if (currentIndex > 0) {
      return focusNodes[currentIndex - 1];
    }
    return null;
  }

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    switch (direction) {
      case TraversalDirection.up:
      case TraversalDirection.left:
        return findPreviousFocus(currentNode) != null;
      case TraversalDirection.down:
      case TraversalDirection.right:
        return findNextFocus(currentNode) != null;
    }
  }

  @override
  Iterable<FocusNode> sortDescendants(Iterable<FocusNode> descendants, FocusNode currentNode) {
    return focusNodes.where((node) => descendants.contains(node));
  }
}
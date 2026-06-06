// modulo_G

import 'dart:async';

import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_movement.dart';
import '../../domain/repositories/products_repository.dart';

class InventoryController extends ChangeNotifier {
  InventoryController({required ProductsRepository repository}) : _repository = repository {
    _startPolling();
  }

  final ProductsRepository _repository;

  // Real-time streams for UI to listen updates without polling UI rebuilds
  final StreamController<Map<String, int>> _stockController = StreamController<Map<String, int>>.broadcast();
  final StreamController<List<ProductMovement>> _movementsController = StreamController<List<ProductMovement>>.broadcast();

  bool _isLoading = false;
  String? _error;
  List<Product> _products = const [];
  List<ProductMovement> _movements = const [];
  Timer? _pollTimer;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => _products;
  List<ProductMovement> get movements => _movements;

  Map<String, int> get currentStock {
    final Map<String, int> map = {};
    for (final p in _products) {
      map[p.id] = 0;
    }

    for (final m in _movements) {
      final current = map[m.productId] ?? 0;
      if (m.type == 'in') {
        map[m.productId] = current + m.quantity;
      } else {
        map[m.productId] = current - m.quantity;
      }
    }

    return map;
  }

  Stream<Map<String, int>> get stockStream => _stockController.stream;
  Stream<List<ProductMovement>> get movementsStream => _movementsController.stream;

  List<ProductMovement> getMovementsForProduct(String productId) {
    final list = _movements.where((m) => m.productId == productId).toList();
    list.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return list;
  }

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prods = await _repository.getAllProducts();
      final movs = await _repository.getAllMovements();
      _products = prods;
      _movements = movs;
      // Push updates to streams for real-time UI
      try {
        _stockController.add(currentStock);
        _movementsController.add(List<ProductMovement>.unmodifiable(_movements));
      } catch (_) {}
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMovement({required String productId, required int quantity, required String type, String? note}) async {
    await _repository.createMovement(productId: productId, quantity: quantity, type: type, note: note);
    await loadAll();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await loadAll();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _stockController.close();
    _movementsController.close();
    super.dispose();
  }
}

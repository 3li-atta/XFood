import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'api_handlers.dart';

/// Configures and returns the shelf Router mapping all REST API endpoints.
class ApiRouter {
  final ApiHandlers _handlers;

  ApiRouter(this._handlers);

  /// Returns the configured Router as a shelf Handler.
  Handler get router {
    final router = Router();

    // Health
    router.get('/api/health', _handlers.handleHealth);

    // Meals (Menu Sync)
    router.get('/api/meals', _handlers.handleGetMeals);

    // Tables
    router.get('/api/tables', _handlers.handleGetTables);
    router.put('/api/tables/<id>/status', _handlers.handleUpdateTableStatus);

    // Pending Orders (Parked Orders)
    router.get('/api/orders/pending', _handlers.handleGetPendingOrders);
    router.post('/api/orders/pending', _handlers.handleCreatePendingOrder);
    router.delete('/api/orders/pending/<id>', _handlers.handleDeletePendingOrder);

    // Finalized Orders (Sales)
    router.post('/api/orders', _handlers.handleCreateOrder);

    // Shift
    router.get('/api/shift/active', _handlers.handleGetActiveShift);

    return router.call;
  }
}

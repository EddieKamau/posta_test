import 'package:backend/backend.dart';
import 'package:backend/controllers/auth_controller.dart';
import 'package:backend/controllers/user_controller.dart';
import 'package:backend/models/model_manager.dart';
import 'package:backend/models/user_model.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class BackendChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    
    final ModelManager modelManager = ModelManager('');
    modelManager.openDb();
  }
  

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();
    router.route("/auth").linkFunction((request) async {
      return Response.unauthorized();
    });


    router.route("/users[/:email]").link(UserController.new);

    return router;
  }
}

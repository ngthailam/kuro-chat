import 'package:injectable/injectable.dart';

abstract class ChatLocalDataSource {}

@Injectable(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl extends ChatLocalDataSource {}

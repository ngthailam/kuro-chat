import 'package:injectable/injectable.dart';

abstract class ChannelLocalDataSource {}

@Injectable(as: ChannelLocalDataSource)
class ChannelLocalDataSourceImpl extends ChannelLocalDataSource {}

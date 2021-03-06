import 'package:flutter/material.dart';
import 'package:social_cv_client_dart_common/blocs.dart';
import 'package:social_cv_client_dart_common/models.dart';
import 'package:social_cv_client_flutter/src/blocs/bloc_provider.dart';
import 'package:social_cv_client_flutter/src/utils/utils.dart';
import 'package:social_cv_client_flutter/src/widgets/error_widget.dart';
import 'package:social_cv_client_flutter/src/widgets/group_list_widget.dart';
import 'package:social_cv_client_flutter/src/widgets/loading_widget.dart';

class PartPage extends StatelessWidget {
  const PartPage({
    Key key,
    @required this.partId,
  })  : assert(partId != null),
        super(key: key);

  final String partId;

  @override
  Widget build(BuildContext context) {
    PartBloc _partBloc = BlocProvider.of<PartBloc>(context);
    _partBloc.fetchPart(partId);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<PartModel>(
          stream: _partBloc.partStream,
          builder: (BuildContext context, AsyncSnapshot<PartModel> snapshot) {
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              PartModel partModel = snapshot.data;
              return Text(partModel.name);
            }
            return LoadingShadowContent(
              numberOfTitleLines: 1,
              numberOfContentLines: 0,
            );
          },
        ),
      ),
      body: _PartPagePartBody(),
    );
  }
}

class _PartPagePartBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PartBloc _partBloc = BlocProvider.of<PartBloc>(context);

    return Stack(
      children: <Widget>[
        StreamBuilder<bool>(
          stream: _partBloc.isFetchingPartStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return LinearProgressIndicator();
            }
            return Container();
          },
        ),
        StreamBuilder<PartModel>(
          stream: _partBloc.partStream,
          builder: (BuildContext context, AsyncSnapshot<PartModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorCard(
                message: translateError(context, snapshot.error),
              );
            } else if (snapshot.hasData) {
              return BlocProvider<GroupListBloc>(
                bloc: GroupListBloc(),
                child: GroupListWidget(
                  fromPartModel: snapshot.data,
                  showOptions: true,
                ),
              );
            }
            return LoadingShadowContent(
              numberOfTitleLines: 0,
              numberOfContentLines: 2,
              padding: EdgeInsets.all(10.0),
            );
          },
        ),
      ],
    );
  }
}

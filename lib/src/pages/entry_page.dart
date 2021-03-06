import 'package:flutter/material.dart';
import 'package:social_cv_client_dart_common/blocs.dart';
import 'package:social_cv_client_dart_common/models.dart';
import 'package:social_cv_client_flutter/src/blocs/bloc_provider.dart';
import 'package:social_cv_client_flutter/src/repositories/repositories_provider.dart';
import 'package:social_cv_client_flutter/src/utils/utils.dart';
import 'package:social_cv_client_flutter/src/widgets/error_widget.dart';
import 'package:social_cv_client_flutter/src/widgets/loading_widget.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({
    Key key,
    @required this.entryId,
  })  : assert(entryId != null),
        super(key: key);

  final String entryId;

  @override
  Widget build(BuildContext context) {
    EntryBloc _entryBloc = BlocProvider.of<EntryBloc>(context);
    RepositoriesProvider _repositories = RepositoriesProvider.of(context);

    _entryBloc.fetchEntry(entryId);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<EntryModel>(
          stream: _entryBloc.entryStream,
          builder: (BuildContext context, AsyncSnapshot<EntryModel> snapshot) {
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              EntryModel entryModel = snapshot.data;
              return Text(entryModel.name);
            }
            return LoadingShadowContent(
              numberOfTitleLines: 1,
              numberOfContentLines: 0,
            );
          },
        ),
      ),
      body: _EntryPageEntryBody(),
    );
  }
}

class _EntryPageEntryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EntryBloc _entryBloc = BlocProvider.of<EntryBloc>(context);

    return Stack(
      children: <Widget>[
        StreamBuilder<bool>(
          stream: _entryBloc.isFetchingEntryStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return LinearProgressIndicator();
            }
            return Container();
          },
        ),
        StreamBuilder<EntryModel>(
          stream: _entryBloc.entryStream,
          builder: (BuildContext context, AsyncSnapshot<EntryModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorCard(
                  message: translateError(context, snapshot.error));
            } else if (snapshot.hasData) {
              EntryModel entryModel = snapshot.data;

              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('name'),
                    subtitle: Text(entryModel.name),
                  ),
                  ListTile(
                    title: Text('type'),
                    subtitle: Text(entryModel.type),
                  ),
                  ListTile(
                    title: Text('content'),
                    subtitle: Text(entryModel.content),
                  ),
                ],
              );
            }
            return LoadingShadowContent(
              numberOfContentLines: 2,
              padding: EdgeInsets.all(10.0),
            );
          },
        ),
      ],
    );
  }
}

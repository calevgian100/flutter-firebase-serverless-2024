// // This piece of code shows how to work with a [FutureBuilder] widget.
// // After the future is completed, the builder is re-run, displaying new information.

// import 'package:flutter/material.dart';
// import 'package:todo_do_app/logic/firestore_service.dart';
// import 'package:todo_do_app/widgets/task_tile.dart';

// class TaskList extends StatelessWidget {
//   TaskList({super.key});

//   final getTaskFuture = FirestoreService.getTasks();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getTaskFuture,
//       builder: (context, snap) {
//         if (snap.hasData && snap.data != null) {
//           return ListView.builder(
//             itemCount: snap.data!.length,
//             itemBuilder: (context, index) {
//               final task = snap.data![index];
//               return TaskTile(task: task);
//             },
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }

// -------------------------------------------------------------------------------
// This piece of code shows how to work with a [StreamBuilder] widget.
// This widget listens a stream and, after the stream receives a new snapshot, the
// builder is re-run, displaying new information.

import 'package:flutter/material.dart';
import 'package:todo_do_app/remote_config/logic/remote_config_service.dart';
import 'package:todo_do_app/to_do_list/logic/firestore_service.dart';
import 'package:todo_do_app/to_do_list/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        if (RemoteConfigService.shouldShowWelcomeMessage())
          Text(RemoteConfigService.getWelcomeMessage()),
        StreamBuilder(
          stream: FirestoreService.listenTasks(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final tasks = snapshot.data!.docs;
              return SizedBox(
                height: size.height * .8,
                width: size.width,
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index].data();
                    task['id'] = tasks[index].id;
                    return TaskTile(task: task);
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}

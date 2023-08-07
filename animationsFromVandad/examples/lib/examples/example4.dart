import 'package:flutter/material.dart';

@immutable
class Person {
  final String name;
  final String age;
  final String emojie;
  const Person({
    required this.name,
    required this.age,
    required this.emojie,
  });
}

const persons = [
  Person(
    name: 'John',
    age: '20',
    emojie: '👨‍🦱',
  ),
  Person(
    name: 'Jane',
    age: '21',
    emojie: '👩‍🦰',
  ),
  Person(
    name: 'Jack',
    age: '22',
    emojie: '👨‍🦳',
  ),
];

class Example4 extends StatelessWidget {
  const Example4({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hero Animation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            leading: Hero(
              tag: person.name,
              child: Text(
                person.emojie,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            title: Text(
              person.name,
              style: const TextStyle(fontSize: 22),
            ),
            subtitle: Text(
              "${person.age} years old",
              style: const TextStyle(fontSize: 20),
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailsPage(person: person);
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          );
        },
      )),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Person person;
  const DetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: person.name,
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              switch (flightDirection) {
                case HeroFlightDirection.push:
                  return Material(
                    color: Colors.transparent,
                    child: ScaleTransition(
                      scale: animation.drive(
                        Tween<double>(
                          begin: 0,
                          end: 1,
                        ).chain(
                          CurveTween(curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      child: toHeroContext.widget,
                    ),
                  );
                case HeroFlightDirection.pop:
                  return Material(
                    color: Colors.transparent,
                    child: fromHeroContext.widget,
                  );
              }
            },
            child: Text(
              person.emojie,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                person.name,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${person.age} years old",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}

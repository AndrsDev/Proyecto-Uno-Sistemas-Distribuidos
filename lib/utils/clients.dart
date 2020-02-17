class Client {
  final int id;
  final String name;
  final String lastName;
  final double balance;

  const Client({this.id, this.name, this.lastName, this.balance});
}


const clients = [
  Client(
    id: 1,
    name: 'Andres',
    lastName: 'Sanabria'
  ),
  Client(
    id: 2,
    name: 'Gabriela',
    lastName: 'Toledo'
  ),
  Client(
    id: 3,
    name: 'Esteban',
    lastName: 'Castillo'
  ),
  Client(
    id: 4,
    name: 'Luis',
    lastName: 'Tello'
  ),
  Client(
    id: 5,
    name: 'Natalia',
    lastName: 'Morales'
  ),
];
enum TaskOptionEnum {
  edit( name: 'Edit'),
  delete(name: 'Delete');
  final String name;
  const TaskOptionEnum({required this.name});

}

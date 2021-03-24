class ChatUser {
  final String id, name, email, imageUrl;

  ChatUser({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
  });

  factory ChatUser.fromMap(Map<String, dynamic> data) {
    return ChatUser(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      imageUrl: data['imageUrl'],
    );
  }
}

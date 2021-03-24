class ConversationID {
  static String getConversationID(String uid, String pid) =>
      uid.hashCode <= pid.hashCode ? uid + '_' + pid : pid + '_' + uid;
}

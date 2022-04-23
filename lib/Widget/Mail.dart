class MailContent {
  String image;
  String subject;
  String time;
  String sender;
  String message;
  String status;


  MailContent(this.image ,this.subject, this.sender, this.time, this.message, this.status);
  String getimage() => this.image;
  String getSubject() => this.subject;
  String getSender() => this.sender;
  String getTime() => this.time;
  String getMessage() => this.message;
  String getstatus() => this.status;

}
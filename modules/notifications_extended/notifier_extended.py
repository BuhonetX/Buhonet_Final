import smtplib
from twilio.rest import Client

class NotifierExtended:
    def send_email(self, recipient, subject, message):
        with smtplib.SMTP('smtp.example.com', 587) as server:
            server.starttls()
            server.login('user@example.com', 'password')
            server.sendmail('user@example.com', recipient, f"Subject: {subject}\n\n{message}")

    def send_sms(self, phone_number, message):
        client = Client('account_sid', 'auth_token')
        client.messages.create(to=phone_number, from_='+1234567890', body=message)

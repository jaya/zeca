# ZECA

Send emails through [Mailgun](https://www.mailgun.com/). Cross domain is enabled for the allowed domains.

#### Routes

    /contact - send emails, requires name, email, phone and message params
    /subscribe - subscribe to mailing list, requires address param

#### Environment Variables

    ALLOWED_DOMAIN
    MAILGUN_API_TOKEN
    MAINGUN_RECEIVER
    MAINGUN_DOMAIN
    MAILGUN_MAILING_LIST

#### Examples

**Send email**

```javascript
$.ajax({
  type: 'POST',
  url: 'http://localhost:4567/contact',
  data: { name: '', email: '', phone: '', message: '' },
  success: function() {
    doSomething();
  }
});
```

**Subscribe to mailing list**

```javascript
$.ajax({
  type: 'POST',
  url: 'http://localhost:4567/subscribe',
  data: { address: 'foo@bar.com' },
  success: function() {
    doSomething();
  }
});
```

#### Development

    $ git clone git@github.com:jaya/zeca.git
    $ cd zeca
    $ bundle install
    $ ruby app.rb

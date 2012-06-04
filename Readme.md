## Set up your environment

This section explains how to prepare your development environment to start working with the Bluevia Ruby SDK. First check out the system requirements that your computer must meet, and then follow the installation steps. Once you have finished you will be able to develop your first Ruby application using the functionality provided by Bluevia APIs.

### System requeriments

The Bluevia library for Ruby is prepared and has been tested to develop applications under Ruby 1.8.7 and 1.9.2. 

The following system requirements are the ones your computer needs to meet to be able to work with the Ruby SDK:

Supported Operating Systems

  - Windows XP (32-bit) or Vista (32- or 64-bit)
  - Mac OS X 10.5.8 or later (x86 only)
  - Linux (tested on Linux Ubuntu 10.10)

Developing environment
  - Eclipse 3.6.2
  - Eclipse RDT plugin (tested on Aptana Radrails 1.4.0)

For complete information visit the system requirements described in Ruby Developers.

### Step 1: Preparing the Ruby environment
The first step to start developing applications is setting up your Ruby environment. You have to download the Ruby SDK and the RDT plugin, in case you choose to use Eclipse as your IDE. If you have already prepared your computer to develop Ruby applications you can skip to step 2; otherwise follow the next instructions:
  - Prepare your development computer and ensure it meets the system requirements.
  - Download a valid library for Ruby (tested on 1.8.7 and 1.9.2) from http://www.ruby-lang.org/en/downloads/.
  - RubyGems: no action necessary (installed with Ruby).
  - Aptana: Now that you have a working, documented version of Ruby on your computer, you need to download a new version or update your Eclipse plug-in, follow Aptana's instructions, which will be familiar to Eclipse users (http://update1.aptana.org/rails/1.2.1.23268/index.html).  

### Step 2: Add BlueVia Ruby SDK in your project
There are two ways include the Bluevia SDK in your Ruby application: 
  - Simply type gem install bluevia-1.6.gem in the command window and include require 'bluevia' in your program.
  - Display the gem typing following commands and add all require needed (f.e. require 'bluevia'): 
	gem install bundler (if not installed)
	bundle install
Dont't forget to include it into your LOAD_PATH directory.

Follow the next steps to set up your Ruby project:
  - If you have Ruby plugin installed you have to select File -> New -> Ruby Project
  - Check that RubyVM for ruby 1.9.2 is selected (in case you have more RubyVM installed)
  - Add Bluevia Library to your project adding (if needed) to your external sources directory and include require 'bluevia' in your program.

## Code samples 
You can find a set of complete sample apps on this repository:

- [/samples/demo_payment](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_payment.rb) : Performs a Payment 
- [/samples/demo_oauth](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_oauth.rb) : Demostrates OAuth process negotiation
- [/samples/demo_sms_mt](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_sms_mt.rb) : Sends SMS and a Check Delivery Status
- [/samples/demo_sms_mo](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_sms_mo.rb) : Receive SMS.
- [/samples/demo_mms_mt](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_mms_mt.rb) : Sends MMS and a Check Delivery Status
- [/samples/demo_mms_mo](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_mms_mo.rb) : Receive MMS.
- [/samples/demo_location](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_location.rb) : Gets the location of a user
- [/samples/demo_directory](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_directory.rb) : Gets user access information
- [/samples/demo_advertising](https://github.com/BlueVia/Official-Library-Ruby/tree/master/samples/demo_advertising.rb) : Gets advertising

Please find below also some quick snippets on how to use the library.


### OAuth proccess negotiation
Most of the APIs need have passed a complete OAuth process once before starting to use them because they will act on behalf a customer (OAuth 3-leggded mode); others, like receiving messages ones, don't need that process (OAuth 2-legged mode). The advertising API, could be used both as 3-legged and as 2-legged.

#### Step 1: Get application keys (consumer keys).
You can get your own application keys for you app at [BlueVia](http://bluevia.com/en/api-keys/get).

#### Step 2: Init oauth process: Do a request tokens
BlueVia APIs authentication is based on [OAuth 1.0](http://bluevia.com/en/page/tech.howto.tut_APIauth)
To get the users authorization for using BlueVia API's on their behalf, you shall do as follows.
By using your API key, you have to create a request token that is required to start the OAuth process. For example:
  # Create the client (you have to include the Consumer credentials)
  @bc = BVOauth.new(BVMode::LIVE, consumer_key, consumer_secret)
  # Retrieve the request token
  request_token = @bc.get_request_token

#### Step 3: User authorisation

There are three alternatives to request the user authorisation:

  - WebOauth authorisation
Callback parameter is a defined callback URL. You will receive the oauth_verifier as a request parameter at your callback.
  @request_token = @service.get_request_token("http://foo.bar/bluevia/get_access")

  - OutOfBand authorisation
To get user authorization using the oauth_token from your request token you have to take the user to BlueVia. The obtained request token contains the verification url to access to the BlueVia portal. Depending on the mode used, it will be available for final users (LIVE) or developers (TEST and SANDBOX). The application should enable the user (customer) to visit the url in any way, where he will have to introduce its credentials (user and password) to authorise the application to connect BlueVia APIs behalf him. Once permission has been granted, the user will obtain a PIN code necessary to exchange the request token for the access token:
  # Open the received url in a browser using an Intent
  redirect_to(@request_token.auth_url)
Once the user confirms the authorization, you have to ask the user to enter the oauth_verifier in your app. Note that your users will need to copy and paste the oauth_verifier manually, so be clear when you request it to be sure they do not get confused.

  - SMSOauth authorisation
Bluevia supports a variation of OAuth process where the user is not using the browser to authorize the application. Instead he will receive an SMS containing he PIN code (oauth_verifier). To use this SMS handshake, get_request_token_smsHandshake request must pass the user's MSISDN (phone number) in callback parameter. After the user had received the PIN code, the application should allow him to enter it and request the access token.
  # Retrieve the request token
  @request_token = @service.get_request_token_smsHandshake("34123456789")

#### Step 4: Get access tokens
With the obtained PIN code (oauth_verifier), you can now get the accessToken from the user as follows:
  #Obtain the access token
  @access_token = @service.get_access_token(pin_code, @request_token.token, @request_token.secret)

Both token and token_secret must be saved in your application because OAuth process will require it later.

### Payment API
Payment API enables your application to make payments behalf the user to let him buy products or pay for services, and request the status of a previous payment.
Bluevia Payment API uses an extension of OAuth protocol to guarantee secure payment operations. For each payment the user makes he must complete the OAuth process to identify itself and get a valid acess token. These tokens will be valid for 48 hours and then will be dismissed.
First, you have to retrieve a request token to be authorised by the user:
  @bc = BVPayment.new(BVMode::LIVE,"[CONSUMER_KEY]","[CONSUMER_SECRET]")
  @payment_request_token = @bc.get_payment_request_token("100", "GBP", "service_name", "service_id", nil)

Note that the callback (last parameter) is an optional value, you can set it to null if your application is not able to receive request from BlueVia. Typically websites set a callback url and desktop or mobile applications don't.
Then, take the user to BlueVia Connect to authorise the application as usual.
Once you have obtained the oauth_verifier, you can now get the accessToken as follows:
  @payment_access_token = @service.get_payment_access_token( USER_PIN_CODE )

Before making a payment transaction you have to set payment tokens in your connector as follows: 
  @bc.set_token(@payment_access_token) 	

Now you can make a payment transaction using payment method:
 response = @bc.payment("100", "GBP", nil, nil)

### Send SMS and get delivery status
SMS API allows your app to send messages on behalf of the users, this means that their mobile number will be the text sender and they will pay for them.

#### Sending SMS
  @bc = BVMtSms.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONSUMER_SECRET]", "[TOKEN_KEY]","[TOKEN_SECRET]") 
  # Send the message. 
  delivery_status_id = @bc.send("34123456789", "This is the text to be sent using Bluevia API")

Your application can send the same SMS to several users including phoneNumber array as follows:
  delivery_status_id = @bc.send(["56123456789", "34123456789"], "This is the text to be sent using Bluevia API")
Take into account that the recipients numbers are required to included the international country calling code.

#### Checking delivery status
After sending an SMS you may need to know if it has been delivered. 
You can poll to check the delivery status.This alternative is used typically for mobile applications without a backend server.
You need to keep the delivery_status_id to ask about the delivery status of that SMS as follows:
  # get_delivery_status returns an array of Bluevia::Schemas::DeliveryInfo objects
  status_obj = @bc.get_delivery_status(delivery_status_id)
  status_obj.each{ |info_sms|
    dest = info_sms.destination
    stat = info_sms.status
    desc = info_sms.status_description
    }

### Send MMS and get delivery status 
MMS API enables your application to send an MMS on behalf of the user, check the delivery status of a sent MMS and Receive an MMS on your application.

#### Sending MMS
  @bc = BVMtMms.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONS UMER_SECRET]", "[TOKEN_KEY]","[TOKEN_SECRET]")
  Several attachments could be attached to the MMS message. The class that represent multipart attachment is Bluevia::Schemas::Attachment:
  filepathmms         = "./sdk_test/text.txt"
  mimetypemms         = "text/plain"   	
      
  # Full path required
  filepathmms= File.expand_path(filepathmms)
  attach = Array.new
  attach << Bluevia::Schemas::Attachment.new(
    filepathmms,
    mimetypemms
    )
  
  # Send the message.
  mms_id = @bc.send("34123456789", "MMS subject", "This is the text to be sent using Bluevia API", attach)

Your application can send the same MMS to several users including a phoneNumber array as follows:
  mms_id = @bc.send(["34123456789", "34987654321"], "MMS subject", "This is the text to be sent using Bluevia API", attach)
Take into account that the recipients numbers are required to included the international country calling code.

#### Checking delivery status
After sending an MMS you may need to know if it has been delivered.
You can poll polling to check the delivery status. This alternative is used typically for mobile applications without a backend server.
You need to keep the deliveryStatusId to ask about the delivery status of that MMS as follows:
  status_obj = @bc.get_delivery_status(mms_id)
	  
  status_obj.each{ |info_mms|
    dest = info_mms.destination
    stat = info_mms.status
    desc = info_mms.status_description
    }

### Receive SMS 
You can can retrieve the SMS sent to your app using OAuth-2-legged auhtorisation so no user access token is required.
  @bc = BVMoSms.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONSUMER_SECRET]")

Your application can receive SMS from users sent to [BlueVia shortcodes](http://bluevia.com/en/page/tech.overview.shortcodes) including your application keyword. You have to take into account that you will need to remember the SMS keyword you defined when you requested you API key.

You can grab messages sent from users to you app as follows:
  list_sms = @bc.get_all_messages("546780")
      
  list_sms.each{|msg|
    dest = msg.destination
    text = msg.message
    orig = msg.origin_address
    }

Note that this is just an example and you should implement a more efficient polling strategy.

### Receive MMS 
You can can retrieve the MMS sent to your app using OAuth-2-legged auhtorisation so no user access token is required.
  @bc = BVMoMMS.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONSUMER_SECRET]")

Your application can receive MMS from users sent to [BlueVia shortcodes](http://bluevia.com/en/page/tech.overview.shortcodes) including your application keyword. You have to take into account that you will need to remember the MMS keyword you defined when you requested you API key. 

You can grab messages sent from users to you app as follows. The Bluevia::Schemas::MmsMessageInfo object contains the information of the sent MMS, but the attachments. In order to retreive attached documents in the MMS you have to use the get_message function, which needs the message_id available in the MmsMessageInfo object. The returned MmsMessage object contains the info of the Mms itself and a list of MimeContent objects with the content of the attachments:

  messages = @bc.get_all_messages("546780", false)
  messages.each{|obj|
    mess_id << obj.message_id
    message = @mo.get_message("546780", obj.message_id)
    attachmentsmes = message.attachments
    attachmentsmes.each_index{|file_att|
      f_at= File.new("attachment#{file_att}", "w")
      f_at.write(attachmentsmes[file_att].content)
      f_at.close
      } 
    }

You can get each attachment separately through get_attachment method:

  messages = @bc.get_all_messages("546780", true)
  messages.each{|obj|
    obj["attachmentURL"].each{|attach|
      url = attach["href"]
      content_type = attach["contentType"]
      # attachment is a MimeContent object
      attachment=@service.get_attachment("546780", obj.message_id, url)
      puts attachment.name
      # You can also save the attachment.content in a file as show before!
      }
    }
Note that this is just an example and you should implement a more efficient polling strategies

### User Context API
User Context API enables your application to get information about the user's customer profile in order to know more about your users to targetize better your product.

#### Getting Profile Information
  profile_information = @bc.get_profile_info

#### Getting Access Information
  access_information = @bc.get_access_info

#### Getting Device Information
  terminal_information = @bc.get_terminal_info

#### Filters
If you want to configure a filter on the information relevant for your application you can do it for any of the requests above:
  terminal_information = @bc.get_terminal_info([Bluevia::Schemas::TerminalFields::BRAND, Bluevia::Schemas::TerminalFields::EMS])

  brand_information = terminal_information.brand
  model_information = terminal_information.model # nil because not requested
  ems_information = terminal_information.ems

### Location API
Location API enables your application to retrieve the geographical coordinates of user. These geographical coordinates are expressed through a latitude, longitude, altitude and accuracy.

The acc_accuracy (optional) parameter expresses the range in meters that the application considers useful. If the location cannot be determined within this range, then the application would prefer not to receive the information.
Once the server responds the user have to retrieve the location information from the returned Bluevia::Schemas::LocationInfo instance. The LocationInfo includes the report_status of the client request and the coordinates containing the location information.

  @bc = BVLocation.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONSUMER_SECRET]", "[TOKEN_KEY]","[TOKEN_SECRET]")
  location = @bc.get_location(acc_accuracy = 500)
  
  status = location.report_status
  latitude = location.coordinates_latitude
  longitude = location.coordinates_longitude

### Advertising API
Adverstising API enables your application to retrieve advertisements. 

You can invoke this API using a 3-leddged client (ouath process passed) or a 2-legged client. This is selected in the client instantiating.
Once configured your client is ready to get advertisements. When retrieving a simple advertisement you can specify a set of request parameters such as type, protection policy, etc. Mandatory parameters are ad_space, that is the identifier you obtained when you registered your application within the Bluevia portal; and protection_policy. The ad_requets_id is an optional parameter (if it is not supplied, the SDK will generate one). For a more detailed description please see the API Reference.
  @bc = BVAdvertising.new(BVMode::LIVE, "[CONSUMER_KEY]","[CONSUMER_SECRET]")
  response = @bc.get_advertising_2l("12921", "UK", nil, nil, Bluevia::Schemas::TypeId::IMAGE, nil, Bluevia::Schemas::ProtectionPolicy::HIGH, nil)

Take into account that the Protection Policy sets the rules for adult advertising, please be careful.
  LOW 	Low, moderately explicit content (I am youth; you can show me moderately explicit content).
  SAFE 	Safe, not rated content (I am a kid, please, show me only safe content).
  HIGH 	High, explicit content (I am an adult; I am over 18 so you can show me any content including very explicit content).

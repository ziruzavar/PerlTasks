This is my simple forum for Image and Video sharing. 
You can create an account and login. 
<img src="https://res.cloudinary.com/zirfuzavar/image/upload/v1633502455/f1_bln9pd.png" style="width: 100%;" alt=""/>

This is the index page. After you login you can go to Profile to change your profile picture.
Then on the landing page again, there are Galery and Movies page.
In the Galery page you can upload an Image and it will be resized automatically in 3 different formats.
In the Movies page you can upload a video and a daemon will collect it, resize it and upload the resized videos.

I am using Apache24 for the webserver. Perl, mod_perl, CGI, HTML::Template and CGI::Session for the actual coding. 
The image resizing is done with the Image::Scale module and the Video resizing is done with the UNIX "ffmpeg" command.
DB: MariaDB with the DBI module
Daemon module: Proc::Daemon

Host a static website on S3
***************************
The goal of this project is to create a static website on S3.
Here is a brief overview of the steps involved. For a detailed
tutorial, see `Hosting a website on S3
<https://docs.aws.amazon.com/AmazonS3/latest/userguide/
HostingWebsiteOnS3Setup.html`_.

1. Create a bucket in us-east-1. Name it whatever you want.
2. Go to properties and allow public access.
3. Go to properties and turn on static website hosting.
   Set the index location to "index.html" and the error
   location to "error/error.html"
4. Go to the permissions tab, and add the following bucket policy.
   Be sure to modify it to use your bucket name.

   ::

     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Sid": "AddPerm",
           "Effect": "Allow",
           "Principal": "*",
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::useyourbucketname/*"
         }
       ]
     }

5. Upload the static website files in ``static-website-files.zip``.
6. Find the endpoint url in the bucket website endpoint section of the
   properties tab and go there. You should see something similar to this:

   .. image:: success.png

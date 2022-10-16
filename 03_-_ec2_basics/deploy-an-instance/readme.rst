Deploy an instance
******************
Requirements:
* Amazon Linux 2
* patched and updated
* public subnet
* Enable Public IP using the associate_public_ip_address parameter
* Allow http
* Run the ``user-data.bash`` script in the VPS.
* Verify the result of the OpenScap Evaluation Report on
  a browser by navigating to your ``http://<publicip>/report.html``.
* Share your OpenScap URL on slack!

<h4>Why I write this tool</h4>
When I am installing an SAP system from scratch. I use the SCP command to upload the downloaded files from SAP download centre to my SAP server. This tool is useful and great except that every time I need to type in the server IP address and destination folder, also my login credential. So I decided to write a small batch program to store that information. Later on, I think why not make it a general tool which can be used by others. Thus, I write this blog to share the work.
<h4>The SAPCP command</h4>
Usually, you will use the scp command as below:
<pre>scp -i &lt;ssh_key_file&gt; &lt;files_to_upload&gt; &lt;user&gt;@&lt;host&gt;:&lt;destination&gt;</pre>
By using my tool, you can use the following command:
<pre>sapcp -h &lt;host&gt; -u &lt;user&gt; -d &lt;destination&gt; -k &lt;ssh_key_file&gt; &lt;files_to_upload&gt;</pre>
All parameters can be ignored by a default value or with environment variables, of course, except the &lt;files_to_upload&gt;.  The parameters are self-explanatory, below is a copy of the usage information of my tool.
<pre><b>Usage</b>:
sapcp [-h &lt;host&gt;] [-u &lt;user&gt;] [-d &lt;destination&gt;] [-k &lt;ssh_key_file&gt;] [-dl] &lt;files...&gt;
  -h Destination host name or ip address.
  -u Logon user to host. Default value: root

  -d Destination directory. Default value: /root/sap_download

  -k Key file for scp connection. Default location is '~\.ssh\id_rsa'.

  -dl Download file from remote server.

  &lt;file&gt; Filename to be uploaded or downloaded. You can use wild char to match multiple files. e.g. *.zip, k*.sar

Use of environment variables:
  You can specify several environment variables to ignore some of the options.
    SAPCP_HOST =&gt; &lt;host&gt;
    SAPCP_USER =&gt; &lt;user&gt;
    SAPCP_DESTINATION =&gt; &lt;destination&gt;
You can always override the environment variable value by specifying the related options, 
e.g. if SAPCP_DESTINATION exists, but you use
    sapcp -d /some_other_dir
The file will be upload to 'some_other_dir' instead of the directory defined in SAPCP_DESTINATION.
</pre>
&nbsp;
<h4>Installation</h4>
Installation steps, you may ignore any step if you did it already.
<ol>
 	<li>Download the 'sapcp.cmd' file to any folder.</li>
 	<li>Add that folder into your path environment variable.</li>
 	<li>Configure the ssh client to generate the ssh_key file.</li>
 	<li>Logon to the remote server, make the destination directory.</li>
 	<li>Configure your local environment variables for SAPCP_HOST, SAPCP_USER, SAPCP_DESTINATION.</li>
 	<li>Done.</li>
</ol>
<h4>Examples:</h4>
If you set up everything ready, the only parameter is the file that you want to upload. E.g.
<pre>sapcp file_to_be_upload.zip</pre>
You don't have to specify the credentials and destination folder every time you run the scp command.

You can also upload all files from a directory:
<pre>sapcp C:\download\*</pre>
The scp command support both direction transfer, so you can download a file. You need to specify the -DL parameter, the default folder is the current folder.
<pre>sapcp -dl file_to_be_download.zip</pre>
<h4>Help me to improve</h4>
I wish my tool can make your life easier. Also, any comment or suggestion is welcome. I can improve the tool to be more flexible and more convenient.

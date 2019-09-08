# sapcp
Usually, you will use the SCP command to upload your downloaded files to the server that you want to install SAP products. The SCP command is useful but not very conveinent if you run it multiple times. You need to type in the destination server, user/password and target directory everytime. So I write this small batch program for convenient use.
<h4>Examples:</h4>
To upload one file from current directory:
<pre>sapcp file_to_be_upload.zip</pre>
To upload all files from a directory:
<pre>sapcp C:\download\*</pre>
To download a file from remote server to current directory:
<pre>sapcp -dl file_to_be_download.zip</pre>
<b>Usage</b>:
<pre>sapcp [-h &lt;host&gt;] [-u &lt;user&gt;] [-d &lt;destination&gt;] [-k &lt;ssh_key_file&gt;] [-dl] &lt;files...&gt;
  -h Destination host name or ip address.
  -u Logon user to host. Default value: root

  -d Destination directory. Default value: /root/sap_download

  -k Key file for scp connection. Default location is '~\.ssh\id_rsa'.

  -dl Download file from remote server.

  &lt;file&gt; Filename to be uploaded or downloaded. You can use wild char to match multiple files. e.g. *.zip, k*.sar
</pre>
<b>Use of environment variables</b>:
  You can specify several environment variables to ignore some of the options.
  <pre>
    SAPCP_HOST =&gt; &lt;host&gt;
    SAPCP_USER =&gt; &lt;user&gt;
    SAPCP_DESTINATION =&gt; &lt;destination&gt;
    </pre>
You can always override the environment variable value by specifying the related options, 
e.g. if `SAPCP_DESTINATION` exists, but you use
    `sapcp -d /some_other_dir`
The file will be upload to `some_other_dir` instead of the directory defined in `SAPCP_DESTINATION`.

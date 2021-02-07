<VirtualHost %ip%:%apache_port%>
	ServerName %domain_idn%
	%domain_aliases%
	ServerAdmin webmaster@%domain%
	DocumentRoot %docroot%
	UseCanonicalName Off
	ScriptAlias /cgi-bin/ %docroot%/cgi-bin/

	CustomLog /usr/local/apache/domlogs/%domain%.bytes bytes
	CustomLog /usr/local/apache/domlogs/%domain%.log combined
	ErrorLog /usr/local/apache/domlogs/%domain%.error.log

	# Custom settings are loaded below this line (if any exist)
	# IncludeOptional "/usr/local/apache/conf/userdata/%user%/%domain%/*.conf"
	
	<IfModule mod_setenvif.c>
		SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on
	</IfModule>

	<IfModule mod_userdir.c>
		UserDir disabled
		UserDir enabled %user%
	</IfModule>

	<IfModule mod_suexec.c>
		SuexecUserGroup %user% %group%
	</IfModule>

	<IfModule mod_suphp.c>
		suPHP_UserGroup %user% %group%
		suPHP_ConfigPath %home%/%user%
	</IfModule>

	<IfModule mod_ruid2.c>
		RMode config
		RUidGid %user% %group%
	</IfModule>

	<IfModule itk.c>
		AssignUserID %user% %group%
	</IfModule>

	<Directory "%docroot%">
		Options -Indexes +FollowSymLinks +SymLinksIfOwnerMatch
		AllowOverride All Options=ExecCGI,Includes,IncludesNOEXEC,Indexes,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks
		Require all granted
	</Directory>

	<IfModule proxy_fcgi_module>
		<FilesMatch \.php$>
			SetHandler "proxy:%backend_fcgi%|fcgi://localhost"
		</FilesMatch>
	</IfModule>


</VirtualHost>

<VirtualHost %ip%:%apache_port%>
	ServerName webmail.%domain_idn%

	<IfModule mod_proxy.c>
		ProxyRequests Off
		ProxyPreserveHost On
		ProxyVia Full
		ProxyPass / http://127.0.0.1:2095/
		ProxyPassReverse / http://127.0.0.1:2095/

		<Proxy *>
			AllowOverride All
		</Proxy>
	</IfModule>

	<IfModule mod_security2.c>
		SecRuleEngine Off
	</IfModule>

</VirtualHost>

<VirtualHost %ip%:%apache_port%>
	ServerName mail.%domain_idn%

	<IfModule mod_proxy.c>
		ProxyRequests Off
		ProxyPreserveHost On
		ProxyVia Full
		ProxyPass / http://127.0.0.1:2095/
		ProxyPassReverse / http://127.0.0.1:2095/

		<Proxy *>
			AllowOverride All
		</Proxy>
	</IfModule>

	<IfModule mod_security2.c>
		SecRuleEngine Off
	</IfModule>

</VirtualHost>

<VirtualHost %ip%:%apache_port%>
	ServerName cpanel.%domain_idn%

	<IfModule mod_proxy.c>

		<IfModule !ssl_module>
			LoadModule ssl_module modules/mod_ssl.so
		</IfModule>
		SSLProxyEngine on
		SSLProxyVerify none
		SSLProxyCheckPeerCN off
		SSLProxyCheckPeerName off
		SSLProxyCheckPeerExpire off
		ProxyRequests Off
		ProxyPreserveHost On
		ProxyVia Full

		RewriteEngine on

		RewriteRule ^/roundcube$ /roundcube/ [R]
		ProxyPass /roundcube/ https://127.0.0.1:2031/roundcube/
		ProxyPassReverse /roundcube https://127.0.0.1:2031/roundcube/

		RewriteRule ^/pma$ /pma/ [R]
		ProxyPass /pma/ https://127.0.0.1:2031/pma/
		ProxyPassReverse /pma https://127.0.0.1:2031/pma/
		
		ProxyPass / https://127.0.0.1:2083/
		ProxyPassReverse / https://127.0.0.1:2083/

		<Proxy *>
			AllowOverride All
		</Proxy>
	</IfModule>

	<IfModule mod_security2.c>
		SecRuleEngine Off
	</IfModule>
	
</VirtualHost>
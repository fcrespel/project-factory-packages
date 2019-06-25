# .bashrc

if [ -d @{product.root}/bin/profile.d ]; then
	for i in @{product.root}/bin/profile.d/*.sh; do
		if [ -r $i ]; then
			. $i > /dev/null 2>&1
		fi
	done
	unset i
fi

rvm use @{ruby.version} > /dev/null 2>&1

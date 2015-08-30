if which a2dissite > /dev/null 2>&1; then
	a2dissite "@{product.id}.conf" > /dev/null 2>&1
fi
disableservice @{package.service}

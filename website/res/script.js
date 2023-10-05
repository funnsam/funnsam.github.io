window.addEventListener('DOMContentLoaded', () => {
	twemoji.parse(document.body, {
		callback: function(icon, options, variant) {
			switch (icon) {
				case 'a9':      // ©
				case 'ae':      // ®
				case '2122':    // ™
					return false;
			}
			return ''.concat(options.base, options.size, '/', icon, options.ext);
		}
	});

	setTimeout(() => {
		try {
			document.getElementById("navbar").contentWindow.location.href;
		} catch(e) {
			document.getElementById("navbar").src += "";
		}
	}, 1000);
});

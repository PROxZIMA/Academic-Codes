<script>
	$j(function(){
		var tn = 'banner_posts';

		/* data for selected record, or defaults if none is selected */
		var data = {
			title: { id: '<?php echo $rdata['title']; ?>', value: '<?php echo $rdata['title']; ?>', text: '<?php echo $jdata['title']; ?>' }
		};

		/* initialize or continue using AppGini.cache for the current table */
		AppGini.cache = AppGini.cache || {};
		AppGini.cache[tn] = AppGini.cache[tn] || AppGini.ajaxCache();
		var cache = AppGini.cache[tn];

		/* saved value for title */
		cache.addCheck(function(u, d){
			if(u != 'ajax_combo.php') return false;
			if(d.t == tn && d.f == 'title' && d.id == data.title.id)
				return { results: [ data.title ], more: false, elapsed: 0.01 };
			return false;
		});

		cache.start();
	});
</script>


<script>
	$j(function(){
		var tn = 'editors_choice';

		/* data for selected record, or defaults if none is selected */
		var data = {
			blog: { id: '<?php echo $rdata['blog']; ?>', value: '<?php echo $rdata['blog']; ?>', text: '<?php echo $jdata['blog']; ?>' }
		};

		/* initialize or continue using AppGini.cache for the current table */
		AppGini.cache = AppGini.cache || {};
		AppGini.cache[tn] = AppGini.cache[tn] || AppGini.ajaxCache();
		var cache = AppGini.cache[tn];

		/* saved value for blog */
		cache.addCheck(function(u, d){
			if(u != 'ajax_combo.php') return false;
			if(d.t == tn && d.f == 'blog' && d.id == data.blog.id)
				return { results: [ data.blog ], more: false, elapsed: 0.01 };
			return false;
		});

		cache.start();
	});
</script>


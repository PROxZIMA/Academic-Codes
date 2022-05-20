<script>
	$j(function(){
		var tn = 'blogs';

		/* data for selected record, or defaults if none is selected */
		var data = {
			category: { id: '<?php echo $rdata['category']; ?>', value: '<?php echo $rdata['category']; ?>', text: '<?php echo $jdata['category']; ?>' }
		};

		/* initialize or continue using AppGini.cache for the current table */
		AppGini.cache = AppGini.cache || {};
		AppGini.cache[tn] = AppGini.cache[tn] || AppGini.ajaxCache();
		var cache = AppGini.cache[tn];

		/* saved value for category */
		cache.addCheck(function(u, d){
			if(u != 'ajax_combo.php') return false;
			if(d.t == tn && d.f == 'category' && d.id == data.category.id)
				return { results: [ data.category ], more: false, elapsed: 0.01 };
			return false;
		});

		cache.start();
	});
</script>


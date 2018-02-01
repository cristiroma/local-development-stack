<h1>Server</h1>
<b>When going through Varnish, this page is cached</b>
<table>
	<thead>
	<tr>
		<th>Name</th>
		<th>Value</th>
	</tr>
	</thead>
	<tbody>
		<?php foreach($_SERVER as $k => $v): ?>
		<tr>
			<td><?php echo $k; ?></td>
			<td><?php echo $v; ?></td>
		</tr>
		<?php endforeach; ?>
	</tbody>
</table>

<script src="/js/jquery.js" type="text/javascript" charset="utf-8"></script> 
<script src="/js/jquery.tagcloud.js" type="text/javascript" charset="utf-8"></script> 
<script language="javascript">
$.fn.tagcloud.defaults = {
    size: {start: 0.9, end: 2, unit: 'em'},
    color: {start: '#8B0B04', end: '#8B0B04'}
};
 
$(function () {
    $('#tag_cloud a').tagcloud();
});
</script>

<script src="/js/jquery.js" type="text/javascript" charset="utf-8"></script> 
<script src="/js/jquery.tagcloud.js" type="text/javascript" charset="utf-8"></script> 
<script language="javascript">
$.fn.tagcloud.defaults = {
    size: {start: 0.7, end: 2.5, unit: 'em'},
    color: {start: '#8B0B04', end: '#8B1C04'}
};
 
$(function () {
    $('#tag_cloud a').tagcloud();
});
</script>

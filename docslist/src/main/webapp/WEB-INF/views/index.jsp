<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article List</title>
	<style>
		.max{
			position: absolute;
			left: 0;
			top: 0;
			z-index: 9999999;	
		}
		.datagrid-header .datagrid-cell span{
	    font-weight: bold;
	    font-size:22px;
	}
	</style>
    <link rel="stylesheet" type="text/css" href="../../resources/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../../resources/themes/icon.css">
    <script type="text/javascript" src="../../resources/jquery.min.js"></script>
    <script type="text/javascript" src="../../resources/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.portal.js"></script>

</head>
<body>
	<div class="easyui-layout" style="width:100%;height:800px">
		<div region="north" class="title" style="height:100px;">
		<h2> Jim Zhu Forbes Interview Project</h2>	
		</div>
		<div region="center">
			<div id="pp" style="position:relative">
				<div style="width:100%;">
				<p>This example shows a datagrid with list of articles. Double click the line will open a new window with 
				specific URL in URL column.</p>
				</div>

			</div>
		</div>
	</div>
	<div id="cc" style="width:100%;height:100%">
		<table id="article_list" ></table>
	</div>
</body>

	<script>
		$(function(){
			$('#pp').portal({
				border:false,
				fit:true
			});
			add();
		});
		function add(){
			var p = $('<div/>').appendTo('body');
			p.panel({
				title:'Article List',
				content:$('#cc'),
				height:600,
				collapsible:true,
				maximizable:false,
				onMaximize: function(){
					var opts = $(this).panel('options');
					var p = $(this).panel('panel');
					opts.fit = false;
					opts.stub = $('<div></div>').insertAfter(p);
					p.appendTo('body').css('position','').addClass('max');
					$(this).panel('resize', {
						width: $(window).width(),
						height: $(window).height()
					});
				},
				onRestore: function(){
					var opts = $(this).panel('options');
					var p = $(this).panel('panel');
					p.insertAfter(opts.stub).removeClass('max');
					opts.stub.remove();
					p.parent().removeClass('panel-noscroll');
				}
			});
			$('#pp').portal('add', {
				panel:p,
				columnIndex:0
			});
			$('#pp').portal('resize');
			
		}

		$('#article_list').datagrid({ 
			url: 'findAllArticle',
			method: 'GET',
			rownumbers: true,
		    fitColumns: true,
		    nowrap: false,
		    remoteSort: false,
		    height:400,
		    striped: true,
		    singleSelect: true,
		    autoRowHeight:false,
		    pagination:true,
		    pageSize:10,
		    toolBar:'',	    
			columns:[[			        
			        {title:'Title',field:'title',align:'left', width:150, sortable:true},  
			        {title:'Content',field:'content',align:'left', width:200, sortable:true},
			        {title:'Author',field:'author',align:'left', width:200, sortable:true}, 
			        {title:'URL',field:'crunchbase_url',align:'left', width:400, sortable:false}			        
			    ]],
			
			onDblClickRow: function(rowIndex, rowData){
				var win = window.open(rowData.crunchbase_url, '_blank');
				if (win) {
				    //Browser has allowed it to be opened
				    win.focus();
				} else {
				    //Browser has blocked it
				    alert('Please allow popups for this website');
				}

			}
		
		});


//********** client side paging *************************************//
		(function($){
            function pagerFilter(data){
                if ($.isArray(data)){    // is array
                    data = {
                        total: data.length,
                        rows: data
                    }
                }
                var target = this;
                var dg = $(target);
                var state = dg.data('datagrid');
                var opts = dg.datagrid('options');
                if (!state.allRows){
                    state.allRows = (data.rows);
                }
                if (!opts.remoteSort && opts.sortName){
                    var names = opts.sortName.split(',');
                    var orders = opts.sortOrder.split(',');
                    state.allRows.sort(function(r1,r2){
                        var r = 0;
                        for(var i=0; i<names.length; i++){
                            var sn = names[i];
                            var so = orders[i];
                            var col = $(target).datagrid('getColumnOption', sn);
                            var sortFunc = col.sorter || function(a,b){
                                return a==b ? 0 : (a>b?1:-1);
                            };
                            r = sortFunc(r1[sn], r2[sn]) * (so=='asc'?1:-1);
                            if (r != 0){
                                return r;
                            }
                        }
                        return r;
                    });
                }
                var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
                var end = start + parseInt(opts.pageSize);
                data.rows = state.allRows.slice(start, end);
                return data;
            }
 
            var loadDataMethod = $.fn.datagrid.methods.loadData;
            var deleteRowMethod = $.fn.datagrid.methods.deleteRow;
            $.extend($.fn.datagrid.methods, {
                clientPaging: function(jq){
                    return jq.each(function(){
                        var dg = $(this);
                        var state = dg.data('datagrid');
                        var opts = state.options;
                        opts.loadFilter = pagerFilter;
                        var onBeforeLoad = opts.onBeforeLoad;
                        opts.onBeforeLoad = function(param){
                            state.allRows = null;
                            return onBeforeLoad.call(this, param);
                        }
                        var pager = dg.datagrid('getPager');
                        pager.pagination({
                            onSelectPage:function(pageNum, pageSize){
                                opts.pageNumber = pageNum;
                                opts.pageSize = pageSize;
                                pager.pagination('refresh',{
                                    pageNumber:pageNum,
                                    pageSize:pageSize
                                });
                                dg.datagrid('loadData',state.allRows);
                            }
                        });
                        $(this).datagrid('loadData', state.data);
                        if (opts.url){
                            $(this).datagrid('reload');
                        }
                    });
                },
                loadData: function(jq, data){
                    jq.each(function(){
                        $(this).data('datagrid').allRows = null;
                    });
                    return loadDataMethod.call($.fn.datagrid.methods, jq, data);
                },
                deleteRow: function(jq, index){
                    return jq.each(function(){
                        var row = $(this).datagrid('getRows')[index];
                        deleteRowMethod.call($.fn.datagrid.methods, $(this), index);
                        var state = $(this).data('datagrid');
                        if (state.options.loadFilter == pagerFilter){
                            for(var i=0; i<state.allRows.length; i++){
                                if (state.allRows[i] == row){
                                    state.allRows.splice(i,1);
                                    break;
                                }
                            }
                            $(this).datagrid('loadData', state.allRows);
                        }
                    });
                },
                getAllRows: function(jq){
                    return jq.data('datagrid').allRows;
                }
            })
        })(jQuery);
 
        function getData(){
            var rows = [];
            for(var i=1; i<=800; i++){
                var amount = Math.floor(Math.random()*1000);
                var price = Math.floor(Math.random()*1000);
                rows.push({
                    inv: 'Inv No '+i,
                    date: $.fn.datebox.defaults.formatter(new Date()),
                    name: 'Name '+i,
                    amount: amount,
                    price: price,
                    cost: amount*price,
                    note: 'Note '+i
                });
            }
            return rows;
        }
        
        $(function(){
            $('#article_list').datagrid({data:getData()}).datagrid('clientPaging');
        });
		
      //********** end of client side paging *************************************//		
		
	</script>






</html>
<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.discovery.configuration.DiscoveryViewConfiguration" %>
<%@page import="org.dspace.app.webui.components.MostViewedBean"%>
<%@page import="org.dspace.app.webui.components.MostViewedItem"%>
<%@page import="org.dspace.discovery.SearchUtils"%>
<%@page import="org.dspace.discovery.IGlobalSearchResult"%>
<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/scholar.css" />
<script type="text/javascript">
    function show(num){
        for(var i=1; i<3; i++){
            document.getElementById("d" + i).style.display = "none";
            document.getElementById("m" + i).style.color = "#666666";
        }
        document.getElementById('d' + num).style.display = "block";
        document.getElementById("m" + num).style.color = "#398db2";
    }
</script>

<%
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
    MostViewedBean mostViewedItem = (MostViewedBean) request.getAttribute("mostViewedItem");
    MostViewedBean mostCitedItem = (MostViewedBean) request.getAttribute("mostCitedItem");
    MostViewedBean mostViewedBitstream = (MostViewedBean) request.getAttribute("mostDownloadedItem");

%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">
<!--添加的内容-->
         <div id="contentqw">
                <div class="scholar-title">
                <p><fmt:message key="jsp.layout.navbar-default.zibian11"/></p>
                </div>
            
                <div class="scholar-fenmianqw">
                <p class="fenmian-ttqw btncolor" id="m1" onclick="show(1)"><fmt:message key="jsp.layout.navbar-default.zibian12"/></p>
                <hr class="tthr"/>
                <p class="fenmian-ttqw1" id="m2" onclick="show(2)"><fmt:message key="jsp.layout.navbar-default.zibian13"/></p>




                </div>

                <div class="scholar-renwuqw">
                    <img class="renwutit" src="<%=request.getContextPath()%>/image/xuezhetit.png" />
                    
                            <div class="tubiaodiv" id="d2" style="display:none;">
                                <a href="http://dl.xunlei.com/" target="_blank"><img class="renwuqw" src="<%=request.getContextPath()%>/image/tubiao.png" /></a>
                                <a href="http://www.iqiyi.com/" target="_blank"><img class="renwuqw" src="<%=request.getContextPath()%>/image/aiqiyi.png" /></a>
                                <a href="http://www.kugou.com/" target="_blank"><img class="renwuqw" src="<%=request.getContextPath()%>/image/kuwo.png" /></a>
                                <a href="http://v.qq.com/" target="_blank"><img class="renwuqw" src="<%=request.getContextPath()%>/image/tengxun.png" /></a>
                                <a href="http://www.pps.tv/" target="_blank"><img class="renwuqw" src="<%=request.getContextPath()%>/image/pps.png" /></a>
                            </div>
                        
                            
                            
                            <div class="tubiaodiv"  id="d1">
                                <a href="http://www.cnki.net" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/nki.png" width="110px" height="30px">
                                </a>
                                 <a href="http://www.wanfangdata.com.cn/" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/wanfang.png" width="110px" height="30px">
                                </a>
                                 <a href="http://www.cqvip.com/" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/weipu.png" width="110px" height="30px">
                                </a>
                                 <a href="http://link.springer.com/" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/springer.png" width="110px" height="30px">
                                </a>
                                 <a href="http://www.sciencedirect.com/" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/science.png" width="110px" height="30px">
                                </a>
                                 <a href="http://onlinelibrary.wiley.com/" target="_blank" class="navitem">
                                    <img src="<%=request.getContextPath()%>/image/willey.png" width="110px" height="30px">
                                </a>
                            </div>
                </div>
            </div>
<!--添加的内容-->                    
                        
<div class="row" style="display: none;">
	
            <div class="container banner">
	<div class="row" style="">
		<div class="" style="float: right;margin-right: 20px;width: 550px;">
		<%= topNews %>
        </div>
        <div class="" style="float: left;width: 600px;height: 250px;"><img style="width: 100%;height: 100%;margin-top: -15px;" class="pull-right" src="<%= request.getContextPath() %>/image/zhuyetu.jpg" alt="DSpace logo" />
        </div>
	
</div>
        

	<%
    	int discovery_panel_cols = 8;
    	int discovery_facet_cols = 4;
    	Map<String, List<FacetResult>> mapFacetes = (Map<String, List<FacetResult>>) request.getAttribute("discovery.fresults");
    	List<DiscoverySearchFilterFacet> facetsConf = (List<DiscoverySearchFilterFacet>) request.getAttribute("facetsConfig");
    	String processorSidebar = (String) request.getAttribute("processorSidebar");
    	String processorGlobal = (String) request.getAttribute("processorGlobal");
          
    if(processorGlobal!=null && processorGlobal.equals("global")) {
		%>
                
<!--搜索和下面三块内容-->
<div class="" style="float: right;">                
	<%@ include file="discovery/static-globalsearch-component-facet.jsp" %>
</div>
                <% } %>        
		  </div>
                  

</div>
<div class="row" style="margin-top:40px;">
	<div class="col-md-4">
		<%@ include file="components/most-viewed.jsp" %>	
	</div>
	<div class="col-md-4">
		<%@ include file="components/most-downloaded.jsp" %>
	</div>
        <!--新近更新-->
	<div class="col-md-4 sm-12">
    <%@ include file="components/recent-submissions.jsp" %>
	</div>
        
	<div class="col-md-4" style="display: none;">
	<%= sideNews %>
	<%-- <%@ include file="components/most-cited.jsp" %> --%>
	</div>
</div>
<%
if (communities != null && communities.length != 0)
{
%>
<div class="row">
	<div class="col-md-5">		
               <h3><fmt:message key="jsp.home.com1"/></h3>
                <p><fmt:message key="jsp.home.com2"/></p>
				<div class="list-group">
<%
	boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.home-page.logos", true);
    for (int i = 0; i < communities.length; i++)
    {
%><div class="list-group-item row">
<%  
		Bitstream logo = communities[i].getLogo();
		if (showLogos && logo != null) { %>
	<div class="col-md-3">
        <img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" /> 
	</div>
	<div class="col-md-9">
<% } else { %>
	<div class="col-md-12">
<% }  %>		
		<h4 class="list-group-item-heading"><a href="<%= request.getContextPath() %>/handle/<%= communities[i].getHandle() %>"><%= communities[i].getMetadata("name") %></a>
<%
        if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
%>
		<span class="badge pull-right"><%= ic.getCount(communities[i]) %></span>
<%
        }

%>
		</h4>
		<p><%= communities[i].getMetadata("short_description") %></p>
    </div>
</div>                            
	
<%
}
}
    
    if(processorSidebar!=null && processorSidebar.equals("sidebar")) {
	%>
	<div class="col-md-7">
	<%@ include file="discovery/static-sidebar-facet.jsp" %>
	</div>
	<% } %>	
</div>
<div class="row">
	<%@ include file="discovery/static-tagcloud-facet.jsp" %>
</div>
</dspace:layout>
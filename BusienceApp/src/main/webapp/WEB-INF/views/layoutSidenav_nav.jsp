<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.Standard.Dto.DTL_TBL"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<meta charset="UTF-8">
		<div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion" style="background: #3B62D1;">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
                        	
                        	<%
                        		List<DTL_TBL> list = (List<DTL_TBL>)session.getAttribute("catagorylist");
                        		
                        		if(list == null)
                        			return;
                        		
                        		List<DTL_TBL> oneList = new ArrayList();
                        		List<DTL_TBL> twoList = new ArrayList();
                        		List<DTL_TBL> threeList = new ArrayList();
                        		List<DTL_TBL> fourList = new ArrayList();
                        		List<DTL_TBL> fiveList = new ArrayList();
                        		
                        		for(int i=0;i<list.size();i++)
                        		{
                        			if(list.get(i).getPARENT().equals("1"))
                        				oneList.add(list.get(i));
                        			
                        			if(list.get(i).getPARENT().equals("2"))
                        				twoList.add(list.get(i));
                        			
                        			if(list.get(i).getPARENT().equals("3"))
                        				threeList.add(list.get(i));
                        			
                        			if(list.get(i).getPARENT().equals("4"))
                        				fourList.add(list.get(i));
                        			
                        			if(list.get(i).getPARENT().equals("5"))
                        				fiveList.add(list.get(i));
                        		}
                        		
                        		for(int j=0;j<fourList.size();j++)
                        		{
                        			//System.out.println(fourList.get(j).toString());
                        		}
                        	%>
                        	
                        	<%!
                        	public void sordList(List<DTL_TBL> list)
                        	{
                        		DTL_TBL minIndex;
                        	    int i, j;
                        	    
                        	    for(i=0;i<list.size()-1;i++)
                        	    {
                        	    	int flag1 = Integer.parseInt(list.get(i).getCHILD_TBL_NUM());
                    	    		int flag2 = Integer.parseInt(list.get(i+1).getCHILD_TBL_NUM());
                        	    }
                        	}
                        	%>
                        	
                            <!-- 리스트 1 -->
                        	<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#oneLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon" style="color: white;"><i class="fas fa-folder"></i></div>
                                <font style="color: white; font-size: 13px;">시스템 관리</font>
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                        	
                            <div class="collapse" id="oneLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                            <%
                        		for(int i=0;i<oneList.size();i++)
                        		{
                        			if(!oneList.get(i).getCHILD_TBL_USE_STATUS().equals("false"))
                        			{
                        	%>
                        			<a style="color: white; font-size: 13px;" class="nav-link" href="${contextPath}/<%=oneList.get(i).getURL()%>"><%=oneList.get(i).getCHILD_TBL_TYPE()%></a>
                        	<%
                        			}
                        		}
                        	%>
                                </nav>
                            </div>
                            
                            <!-- 리스트 2 -->
                            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#twoLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon" style="color: white;"><i class="fas fa-folder"></i></div>
                                <font style="color: white; font-size: 13px;">기준 정보 관리</font>
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                        	
                            <div class="collapse" id="twoLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                            <%
                        		for(int i=0;i<twoList.size();i++)
                        		{
                        			if(!twoList.get(i).getCHILD_TBL_USE_STATUS().equals("false"))
                        			{
                        	%>
                        			<a style="color: white; font-size: 13px;" class="nav-link" href="${contextPath}/<%=twoList.get(i).getURL()%>"><%=twoList.get(i).getCHILD_TBL_TYPE()%></a>
                        	<%
                        			}
                        		}
                        	%>
                                </nav>
                            </div>
                            
                            <!-- 리스트 3 -->
                            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#threeLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon" style="color: white;"><i class="fas fa-folder"></i></div>
                                <font style="color: white; font-size: 13px;">생산 관리</font>
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                        	
                            <div class="collapse" id="threeLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                            <%
                        		for(int i=0;i<threeList.size();i++)
                        		{
                        			if(!threeList.get(i).getCHILD_TBL_USE_STATUS().equals("false"))
                        			{
                        	%>
                        			<a style="color: white; font-size: 13px;" class="nav-link" href="${contextPath}/<%=threeList.get(i).getURL()%>"><%=threeList.get(i).getCHILD_TBL_TYPE()%></a>
                        	<%
                        			}
                        		}
                        	%>
                                </nav>
                            </div>
                            
                            <!-- 리스트 4 -->
                            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#fourLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon" style="color: white;"><i class="fas fa-folder"></i></div>
                                <font style="color: white; font-size: 13px;">품질 관리</font>
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                        	
                            <div class="collapse" id="fourLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                            <%
                        		for(int i=0;i<fourList.size();i++)
                        		{
                        			if(!fourList.get(i).getCHILD_TBL_USE_STATUS().equals("false"))
                        			{
                        	%>
                        			<a style="color: white; font-size: 13px;" class="nav-link" href="${contextPath}/<%=fourList.get(i).getURL()%>"><%=fourList.get(i).getCHILD_TBL_TYPE()%></a>
                        	<%
                        			}
                        		}
                        	%>
                                </nav>
                            </div>
                            
                            <!-- 리스트 5 -->
                            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#fiveLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon" style="color: white;"><i class="fas fa-folder"></i></div>
                                <font style="color: white; font-size: 13px;">관제 기능</font>
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                        	
                            <div class="collapse" id="fiveLayouts" aria-labelledby="headingOne" data-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                            <%
                        		for(int i=0;i<fiveList.size();i++)
                        		{
                        			if(!fiveList.get(i).getCHILD_TBL_USE_STATUS().equals("false"))
                        			{
                        	%>
                        			<a style="color: white; font-size: 13px;" class="nav-link" href="${contextPath}/<%=fiveList.get(i).getURL()%>"><%=fiveList.get(i).getCHILD_TBL_TYPE()%></a>
                        	<%
                        			}
                        		}
                        	%>
                                </nav>
                            </div>
                        </div>
                    </div>
                </nav>
            </div>
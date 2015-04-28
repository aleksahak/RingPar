<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sreg.ResultsBean" %>
<%@ page import="java.util.HashMap" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%
	response.setHeader("Cache-control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader ("Expires", 0);
%>

<html:html locale="true">
<head>

<meta http-equiv="expires" content="0"/>
<meta name="robots" content="noarchive"/>
<title><bean:message key="all.jsp.page.heading"/></title>
<SCRIPT LANGUAGE="JavaScript">
function disableFormNC() { 

if (document.all || document.getElementById) {
document.body.style.cursor="wait";
for (j = 0; j < document.forms.length; j++) {
for (i = 0; i < document.forms[j].length; i++) {
var tempobj = document.forms[j].elements[i];
if (tempobj.name == "analyse" || tempobj.name=="clear" )
tempobj.disabled = true;
}
}
return true;
}
else {
return false;
   }
}

function disableFormAll(){
if (document.all || document.getElementById) {
document.body.style.cursor="wait";
for (j = 0; j < document.forms.length; j++) {
for (i = 0; i < document.forms[j].length; i++) {
var tempobj = document.forms[j].elements[i];
if (tempobj.name == "analyse" || tempobj.name == "clear" || tempobj.name=="cancel")
tempobj.disabled = true;
}
}
return true;
}
else {
return false;
   }
}


function retFalse () {
return false;
}
//  End -->
</script>

</head>

<body bgcolor="white"><p>

	<table border="0" cellpadding="2" cellspacing="10"  width="100%">
    <tr><td text="white" bgcolor="#7DC623" colspan="3">
    <table border="0" cellpadding="2" cellspacing="0" width="100%">
    <tr>
    <td width="100%">  <h1><font color="white">
    <bean:message key="all.jsp.page.heading"/>
    </font></h1>
    </td>
    <td>&nbsp;</td>
    <td nowrap></td>
    <td></td>
    </tr>
    </table>
    </td></tr>
    <tr><td>
    <hr noshade="" size="1"/>
    </td></tr>
    </table>
    
	<table border="0" cellpadding="12" cellspacing="0" width="100%">
		<tr>
			<br/>
		</tr>
	 <tr> 
		 <td align="left" colspan ="2">This server helps you to extract coefficients for ring current and/or electric field effects on nuclear shielding constants or their anisotropies via the fitting scheme that you specify. Please see the manual and the associated publication for full details.</td> 
	 </tr>
	 <tr> 
		 <td align="left" colspan ="2"><a href="manual.pdf" target="_blank">Detailed Instructions</a> </td> 
	 </tr>

		<tr>
			<br/>
		</tr>
	
		<html:form action="enterdata.do" method="POST" enctype="multipart/form-data"  onsubmit="return disableFormNC();">
		 <tr> 
			 <td align="left" colspan ="3"> 
			 <h2>Choose the required arguments for getting the coefficients.</h2> 
			
			 </td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="principalterm"  > 
				 <html:option value="NSC">NSC </html:option> </br> 
				 <html:option value="ANSC">ANSC </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="principalterm"/></strong></font>Choose the NMR observable, for which the parameters are required.</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="nucleus"  > 
				 <html:option value="H">H </html:option> </br> 
				 <html:option value="C">C </html:option> </br> 
				 <html:option value="N">N </html:option> </br> 
				 <html:option value="O">O </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="nucleus"/></strong></font>Choose the atom type, for which the fitting and parameters are requested.</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="adjacency"  > 
				 <html:option value="ALL">ALL </html:option> </br> 
				 <html:option value="NONH">NONH </html:option> </br> 
				 <html:option value="NONHbondedH">NONHbondedH </html:option> </br> 
				 <html:option value="hbonded">hbonded </html:option> </br> 
				 <html:option value="adj">adj </html:option> </br> 
				 <html:option value="spatial">spatial </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="adjacency"/></strong></font>Enter the type of the query atom - ring spatial arrangement to account in fitting and coefficient/plot production.</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="depmode"  > 
				 <html:option value="RCEF">RCEF </html:option> </br> 
				 <html:option value="RC">RC </html:option> </br> 
				 <html:option value="EF">EF </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="depmode"/></strong></font>Enter the physical effects that are to be used in fitting (RC - ring current only, EF - electric field only, RCEF - both). </td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="method"  > 
				 <html:option value="HM">HM </html:option> </br> 
				 <html:option value="P">P </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="method"/></strong></font>Choose the ring current model for the usage of its geometric factor in the fitting procedure (HM - Haigh-Mallion, P - Pople's point dipole).</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:select property="fittingmode"  > 
				 <html:option value="separate">separate </html:option> </br> 
				 <html:option value="joint">joint </html:option> </br> 
			 </html:select> </td>
			 <td align="left" width ="75%"><font color="red"><strong><html:errors property="fittingmode"/></strong></font>Choose the fitting mode for the treatment of ring current effects. Separate treatment means that the ring current coefficients will be assumed different for different types (atom and nucleic acid base) of query nuclei.</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>
		 <tr> 
			 <td align="left" width ="20%"><html:checkbox property="donotprintcorline" /></td> 
			 <td align="left" width ="75%">  <font color="red"><strong><html:errors property="donotprintcorline"/></strong></font> Check this box to remove correlation line from the resulting plot.</td> 
			 <td align="left" width ="5%"><br/><br/></td> 
		 </tr>

	<tr><td>
		<html:hidden property="procFlag" value="enter"/>
  		<html:submit property="analyse">Analyse</html:submit><br/>
	</td></tr>
	</html:form>
	

	<tr><td>
		<font color="red"><strong><html:errors property="org.apache.struts.action.GLOBAL_MESSAGE"/></strong></font>
		<font color="green"><strong><html:errors property="warning"/></strong></font>
	</td></tr>
		
	<logic:present name="inputdata" scope="session">
    	<logic:notEmpty name="inputdata" property="success" scope="session">
    		
    	<tr><td>
    		<hr noshade="" size="1"/>
    	</td></tr>
    	  	
    	
    	
	 <logic:notEmpty name="inputdata" property="submitID"> 
	 <tr><td> 
	<h2>Current Results Files</h2> 
	</td></tr> 
	 <bean:define id="currentSubmitID" name="inputdata" property="submitID" type="String"/> 
	 </table> 
	 <table border="0" cellpadding="12" cellspacing="0" width="100%"> 
	 <tr> 
	 <td colspan="1" align="left" valign="top"> <object type="image/jpeg" data="displayfile.do?subid=<%= currentSubmitID %>&amp;ctype=jpg&amp;file=plot.jpg"  width="450" height="450"></object> </td> 

	 </tr>
	 </table> 
	 <table border="0" cellpadding="12" cellspacing="0" width="100%"> 
	 <tr> 
	 <td colspan="1" align="left" valign="top"> <object type="text/plain"  data="displayfile.do?subid=<%= currentSubmitID %>&amp;ctype=txt&amp;file=coefficients.txt" width="700" height="150"></object> </td> 

	 </tr>
	 </table> 
	 </logic:notEmpty> 

<table border="0" cellpadding="12" cellspacing="0" width="100%">   	
    	    
    	<tr><td>
			<h2>Results Pages</h2>
		</td></tr>
		<logic:notEmpty name="inputdata" property="subList" scope="session">
		<logic:iterate id="sub"  name="inputdata"  indexId="ind" property="subList" type="ResultsBean">
		<bean:define id="listSubID" name="sub" property="submitID" type="String"/>
    	<tr>
    		<td align="left" width=30%>
             	<html:link forward="Results" paramId="resSubID" paramName="listSubID" target="_blank"> Results for submission: <bean:write name="sub" property="submitID"/> </html:link>
             	<br/>
        	</td>
        	<td align="left" width=70%>
        		Parameter values:&nbsp;
        		<logic:iterate id="params"  name="sub"  indexId="pind" property="parList">
  	           		<bean:write name="params" property="key"/>&nbsp;=&nbsp;
  	           		<logic:notEmpty name="params" property="value">
  	           		<bean:write name="params" property="value"/>
  	           		</logic:notEmpty>
  	           		<logic:empty name="params" property="value">
  	           		""
  	           		</logic:empty>
  	           		<%  int ip = pind.intValue();
            			String ipos = Integer.toString(ip);%>
  	           		<logic:notEqual name="inputdata" property="numParams" value="<%= ipos%>">,&nbsp;</logic:notEqual>
  	           		<logic:equal name="inputdata" property="numParams" value="<%= ipos%>">.&nbsp;</logic:equal>
  	        	</logic:iterate>
  	        	
  	        	<br/>
  	        	<logic:iterate id="zlist"  name="sub"  property="zpList">
  	        		<bean:write name="zlist" property="key"/>&nbsp;(files unzipped):<br/>
  	        		<bean:define id="fnames" name="zlist" property="value"/>
  	        		<logic:iterate id="fn"  name="fnames">
  	        			<bean:write name="fn"/>&nbsp;&nbsp;
  	        		</logic:iterate>
  	        		<br/>
  	        	</logic:iterate>
  	        	
  	    	</td>
        </tr>
        </logic:iterate>
        </logic:notEmpty>
        
        <tr><td colspan = "2">
            <br/>
            <html:form action="clearpage.do"  onsubmit="return disableFormAll();">
            <html:hidden property="procFlag" value="clear"/>
	        <html:submit property="clear">Clear Page</html:submit> 
            </html:form>
     	</td></tr>
        
        
    	</logic:notEmpty>
	</logic:present>
	
  
</table>

</body>
</html:html>

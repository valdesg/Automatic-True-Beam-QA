function update_couch_position_flexmap(file_name, couch_vector_name) 
% this functions generates an XML file where the position of the couch on
% the first CP has been updated to position given by the vector
% couch_vector_name. This function is especially usefull for the geometry
% calibration.
%
% @param file_name the name of the XML file whose couch position will be
% updated. The name should be written without extention. 
% @param couch_vector_name the name of the variable located in the same folder as the
% function that contains the couch position. This variable is a 1 by 4
% vector where the first position is the vertical, the secon the Lateral,
% the third is the Longitudinal and the fourth is the Rotational.
%

couch_vector = importdata([couch_vector_name '.mat']);

xDoc = xmlread([file_name '.xml']); 
xRoot = xDoc.getDocumentElement();

CouchVrt_Node_List = xRoot.getElementsByTagName('CouchVrt');
CouchLat_Node_List = xRoot.getElementsByTagName('CouchLat');
CouchLng_Node_List = xRoot.getElementsByTagName('CouchLng');
CouchRtn_Node_List = xRoot.getElementsByTagName('CouchRtn');

CouchVrt_new_text=  xDoc.createTextNode(num2str(couch_vector(1)));
CouchLat_new_text = xDoc.createTextNode(num2str(couch_vector(2)));
CouchLng_new_text = xDoc.createTextNode(num2str(couch_vector(3)));
CouchRtn_new_text = xDoc.createTextNode(num2str(couch_vector(4)));

CouchVrt_Node_List.item(0).replaceChild(CouchVrt_new_text,CouchVrt_Node_List.item(0).getFirstChild());
CouchLat_Node_List.item(0).replaceChild(CouchLat_new_text,CouchLat_Node_List.item(0).getFirstChild());
CouchLng_Node_List.item(0).replaceChild(CouchLng_new_text,CouchLng_Node_List.item(0).getFirstChild());
CouchRtn_Node_List.item(0).replaceChild(CouchRtn_new_text,CouchRtn_Node_List.item(0).getFirstChild());

xmlwrite([file_name '_couchpositionupdated.xml'],xDoc);

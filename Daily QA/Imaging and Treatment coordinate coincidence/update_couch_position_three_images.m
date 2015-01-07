function update_couch_position_three_images(file_name, couch_vector_KV_planar, couch_vector_MV_planar, couch_vector_KV_CBCT) 
% this functions generates an XML file where the position of the couch for
% each of the imaging modalities of the True Beam are updated depending on
% the four dimension vector that is an external variable
%
% @param file_name the name of the XML file whose couch position will be
% updated. The name should be written without extention. 
% @param couch_vector_KV_planar the name of the variable that contains the couch position for the KV planar image. The variable is located in the same folder as the
% function.
% @param couch_vector_MV_planar the name of the variable that contains the couch position for the MV planar image. The variable is located in the same folder as the
% function.
%@param couch_vector_KV_CBCT the name of the variable that contains the couch position for the KV CBCT image. The variable is located in the same folder as the
% function.
%NOTE: In all position vectors, elements are distributed as follow
% - first: Vertical, Second: Lateral, Third: Longitudinal, Fourth:
% Rotational.
% @OUTPUT: An XML file equivalent to the one contain in file_name but where
% th epositions of the vector has been updated.
%NOTE: For this function to work the XML has to have a very tight
%structure. 

%Reading the xml file that will be updated
xDoc = xmlread([file_name '.xml']); 
xRoot = xDoc.getDocumentElement();

% getting the list of all the nodes that describe the Couch Position
CouchVrt_Node_List = xRoot.getElementsByTagName('CouchVrt');
CouchLat_Node_List = xRoot.getElementsByTagName('CouchLat');
CouchLng_Node_List = xRoot.getElementsByTagName('CouchLng');
CouchRtn_Node_List = xRoot.getElementsByTagName('CouchRtn');

% Establishing the positions at which the couch vector nodes for the
% different images appear on the XML document. Note that it starts with 1
% because there is an initial position which is not used for any image. 
KV_planar_node_position = 1;
MV_planar_node_position = 2;
KV_CBCT_node_position = 3;

%updating the position for the KV planar image
couch_vector_KV_p = importdata([couch_vector_KV_planar '.mat']);

CouchVrt_new_text=  xDoc.createTextNode(num2str(couch_vector_KV_p(1)));
CouchLat_new_text = xDoc.createTextNode(num2str(couch_vector_KV_p(2)));
CouchLng_new_text = xDoc.createTextNode(num2str(couch_vector_KV_p(3)));
CouchRtn_new_text = xDoc.createTextNode(num2str(couch_vector_KV_p(4)));

CouchVrt_Node_List.item(KV_planar_node_position).replaceChild(CouchVrt_new_text,CouchVrt_Node_List.item(KV_planar_node_position).getFirstChild());
CouchLat_Node_List.item(KV_planar_node_position).replaceChild(CouchLat_new_text,CouchLat_Node_List.item(KV_planar_node_position).getFirstChild());
CouchLng_Node_List.item(KV_planar_node_position).replaceChild(CouchLng_new_text,CouchLng_Node_List.item(KV_planar_node_position).getFirstChild());
CouchRtn_Node_List.item(KV_planar_node_position).replaceChild(CouchRtn_new_text,CouchRtn_Node_List.item(KV_planar_node_position).getFirstChild());

%updating the position for the MV planar image
couch_vector_MV_p = importdata([couch_vector_MV_planar '.mat']);

CouchVrt_new_text=  xDoc.createTextNode(num2str(couch_vector_MV_p(1)));
CouchLat_new_text = xDoc.createTextNode(num2str(couch_vector_MV_p(2)));
CouchLng_new_text = xDoc.createTextNode(num2str(couch_vector_MV_p(3)));
CouchRtn_new_text = xDoc.createTextNode(num2str(couch_vector_MV_p(4)));

CouchVrt_Node_List.item(MV_planar_node_position).replaceChild(CouchVrt_new_text,CouchVrt_Node_List.item(MV_planar_node_position).getFirstChild());
CouchLat_Node_List.item(MV_planar_node_position).replaceChild(CouchLat_new_text,CouchLat_Node_List.item(MV_planar_node_position).getFirstChild());
CouchLng_Node_List.item(MV_planar_node_position).replaceChild(CouchLng_new_text,CouchLng_Node_List.item(MV_planar_node_position).getFirstChild());
CouchRtn_Node_List.item(MV_planar_node_position).replaceChild(CouchRtn_new_text,CouchRtn_Node_List.item(MV_planar_node_position).getFirstChild());

%updating the position for the KV CBCT image
couch_vector_KV_CT = importdata([couch_vector_KV_CBCT '.mat']);

CouchVrt_new_text=  xDoc.createTextNode(num2str(couch_vector_KV_CT(1)));
CouchLat_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(2)));
CouchLng_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(3)));
CouchRtn_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(4)));

CouchVrt_Node_List.item(KV_CBCT_node_position).replaceChild(CouchVrt_new_text,CouchVrt_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchLat_Node_List.item(KV_CBCT_node_position).replaceChild(CouchLat_new_text,CouchLat_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchLng_Node_List.item(KV_CBCT_node_position).replaceChild(CouchLng_new_text,CouchLng_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchRtn_Node_List.item(KV_CBCT_node_position).replaceChild(CouchRtn_new_text,CouchRtn_Node_List.item(KV_CBCT_node_position).getFirstChild());

%generating the output
xmlwrite([file_name '_couchpositionupdated.xml'],xDoc);

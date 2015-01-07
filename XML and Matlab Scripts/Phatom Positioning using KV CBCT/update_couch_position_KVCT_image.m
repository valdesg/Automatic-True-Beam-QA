function update_couch_position_KVCT_image(file_name, couch_vector_KV_CBCT_file) 
% this functions generates an XML file where the position of the couch for
% each of the imaging modalities of the True Beam are updated depending on
% the four dimension vector that is an external variable
%
% @param file_name the name of the XML file whose couch position will be
% updated. The name should be written without extention. 
%@param couch_vector_KV_CBCT the name of the variable that contains the couch position for the KV CBCT image. The variable is located in the same folder as the
% function.
%NOTE: In all position vectors, elements are distributed as follow
% - first: Vertical, Second: Lateral, Third: Longitudinal, Fourth:
% Rotational.
% @OUTPUT: An XML file equivalent to the one contain in file_name but where
% th epositions of the vector has been updated.
%NOTE: For this function to work the XML has to have a very tight
%structure. 

%Reading the xml file
xDoc = xmlread(file_name); 
xRoot = xDoc.getDocumentElement();

% getting the list of all the nodes that describe the Couch Position
CouchVrt_Node_List = xRoot.getElementsByTagName('CouchVrt');
CouchLat_Node_List = xRoot.getElementsByTagName('CouchLat');
CouchLng_Node_List = xRoot.getElementsByTagName('CouchLng');
CouchRtn_Node_List = xRoot.getElementsByTagName('CouchRtn');

% Establishing the positions at which the couch vector nodes for the
% different images appear on the XML document. Note that it starts with 1
% because there is an initial position which is not used for any image. 
KV_CBCT_node_position = 0;

%updating the position for the KV CBCT image
couch_vector_KV_CT = importdata(couch_vector_KV_CBCT_file);

%Converting the Couch Position from IEC scale to Varian Scale

%Vertical
couch_vector_KV_CT(1) = 100 - couch_vector_KV_CT(1);

%Lateral
couch_vector_KV_CT(2) = 100 + couch_vector_KV_CT(2);

%Longitudinal
couch_vector_KV_CT(3) = couch_vector_KV_CT(3);

%Rotational
couch_vector_KV_CT(4) = couch_vector_KV_CT(4);

%Updating the tests
CouchVrt_new_text=  xDoc.createTextNode(num2str(couch_vector_KV_CT(1)));
CouchLat_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(2)));
CouchLng_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(3)));
CouchRtn_new_text = xDoc.createTextNode(num2str(couch_vector_KV_CT(4)));

CouchVrt_Node_List.item(KV_CBCT_node_position).replaceChild(CouchVrt_new_text,CouchVrt_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchLat_Node_List.item(KV_CBCT_node_position).replaceChild(CouchLat_new_text,CouchLat_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchLng_Node_List.item(KV_CBCT_node_position).replaceChild(CouchLng_new_text,CouchLng_Node_List.item(KV_CBCT_node_position).getFirstChild());
CouchRtn_Node_List.item(KV_CBCT_node_position).replaceChild(CouchRtn_new_text,CouchRtn_Node_List.item(KV_CBCT_node_position).getFirstChild());

%generating the output
xmlwrite('KV CBCT image for phantom positioning updated.xml',xDoc);

function generate_flex_map_xml(file_name) 
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

xDoc = xmlread(file_name); 
xRoot = xDoc.getDocumentElement();

%obtaining the Control Points element
ControlPoints_Node_List = xRoot.getElementsByTagName('ControlPoints');

%obtaining the Imaging Points and Imaging Point Element
ImagingPoints_Node_List = xRoot.getElementsByTagName('ImagingPoints');
ImagingPoint_Node_List = xRoot.getElementsByTagName('ImagingPoint');

%initializing values
portal_image_number = 0;
cp_portal_image_indixe = 0;
AcquisitionId_element_text = 0;
cp_element_from_imaging_point_text = 2;


for i=0:1:360
gantry_angle = i;
cp_gantry_labeled = 2*i + 1;
portal_image_number = portal_image_number + 1;
cp_portal_image_indixe = cp_portal_image_indixe + 2;
AcquisitionId_element_text = i + 2;
cp_element_from_imaging_point_text = i*2 + 4;
    
% Creating the gantry element that will be appended to the Cp element. 
GantryRtn_element = xDoc.createElement('GantryRtn');
GantryRtn_value_textelement = xDoc.createTextNode(num2str(gantry_angle));
GantryRtn_element.appendChild(GantryRtn_value_textelement);

% Creating the Cp element who will have the gantry appended. 
cp_element_with_gantry = xDoc.createElement('Cp');
cp_element_with_gantry.appendChild(GantryRtn_element); 
cp_element_with_gantry.appendChild(xDoc.createComment(['cp'  num2str(cp_gantry_labeled) ': Used to rotate the Gantry for the portal image ' num2str(portal_image_number)]));

%creating the Cp element
cp_element = xDoc.createElement('Cp');
cp_element.appendChild(xDoc.createComment(['cp'  num2str(cp_portal_image_indixe) ': Use dummy cp to index portal image number: ' num2str(portal_image_number)]));


%Appending the Cp and the Cp with Gantry elements + their comments to the
%Checkpoints node
ControlPoints_Node_List.item(0).appendChild(cp_element_with_gantry);
ControlPoints_Node_List.item(0).appendChild(cp_element);

%Creating the Imaging Point Element
ImagingPoint_Element = ImagingPoint_Node_List.item(1).cloneNode(true);

%obtaining the Cp and the Acquisition ID element from the Imaging Point
%Element
cp_element_from_imaging_point = ImagingPoint_Element.getElementsByTagName('Cp');
AcquisitionId_element_from_imaging_point = ImagingPoint_Element.getElementsByTagName('AcquisitionId');

%Creating the text elements that will replace those for the Cp  and AcquisitionId element  
AcquisitionId_element_from_imaging_point_new_text = xDoc.createTextNode(num2str(AcquisitionId_element_text));
cp_element_from_imaging_point_new_text=  xDoc.createTextNode(num2str(cp_element_from_imaging_point_text)); 


%Replacing the text element of the Cp and the Acquisition ID element from the Imaging Point
%Element
cp_element_from_imaging_point.item(0).replaceChild(cp_element_from_imaging_point_new_text,cp_element_from_imaging_point.item(0).getFirstChild());
AcquisitionId_element_from_imaging_point.item(0).replaceChild(AcquisitionId_element_from_imaging_point_new_text ,AcquisitionId_element_from_imaging_point.item(0).getFirstChild());

% Appending the new Imaging Point Element to the Imaging Points element 
ImagingPoints_Node_List.item(0).appendChild(ImagingPoint_Element); 

end

%generating the output
xmlwrite('KV flexmap check.xml',xDoc);

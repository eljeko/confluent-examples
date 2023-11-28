{{$aname := name}}
{{$asurname := surname}}
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES ({{counter "mycounter" 1 1}}, '{{$aname}}', '{{$asurname}}', '{{street}} {{building 3}}', '{{zip}}', '{{city}}' ,'{{state}}','{{username $aname $asurname }}')
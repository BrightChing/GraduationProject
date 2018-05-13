DELETE FROM `user`;
insert INTO user (id, password) values ('admin', '01137E49CKK7253713495K7D5K00EE13');
DELETE FROM `department`;
INSERT INTO department (departmentId, departmentName, parentId)
VALUES (1, '公司', null),
  (2, '财务部门', 1),
  (3, '财务部门1', 2),
  (4, '财务部门2', 2),
  (5, '行政部门', 1),
  (6, '行政部门1', 5),
  (7, '行政部门2', 5),
  (8, '行政部门1-1', 6),
  (9, '行政部门2-1', 7);
DELETE FROM `person`;
INSERT INTO person (personId,loginId, personName,password, position, email, phone, address, departmentId)
VALUES
  (1,   'name-01','login01', '25DBB8365K5K5KK71324K68093EEEDED', '策划', '31401301@qq.com', '15196871601', 'address-01', 1),
  (2,   'name-02','login02', '25DBB8365K5K5KK71324K68093EEEDED', '人事', '31401302@qq.com', '15196871602', 'address-02', 3),
  (3,   'name-03','login03', '25DBB8365K5K5KK71324K68093EEEDED', '程序员', '31401303@qq.com', '15196871603', 'address-03', 9),
  (4,   'name-04','login04', '25DBB8365K5K5KK71324K68093EEEDED', 'position-04', '31401304@qq.com', '15196871604', 'address-04', 1),
  (5,   'name-05','login05', '25DBB8365K5K5KK71324K68093EEEDED', 'position-05', '31401305@qq.com', '15196871605', 'address-05', 2),
  (6,   'name-06','login06', '25DBB8365K5K5KK71324K68093EEEDED', 'position-06', '31401306@qq.com', '15196871606', 'address-06', 6),
  (7,   'name-07','login07', '25DBB8365K5K5KK71324K68093EEEDED', 'position-07', '31401307@qq.com', '15196871607', 'address-07', 4),
  (8,   'name-08','login08', '25DBB8365K5K5KK71324K68093EEEDED', 'position-08', '31401308@qq.com', '15196871608', 'address-08', 8),
  (9,   'name-09','login09', '25DBB8365K5K5KK71324K68093EEEDED', 'position-09', '31401309@qq.com', '15196871609', 'address-09', 9),
  (10,  'name-10','login10', '25DBB8365K5K5KK71324K68093EEEDED', 'position-10', '31401310@qq.com', '15196871610', 'address-10', 4),
  (11,  'name-11','login11', '25DBB8365K5K5KK71324K68093EEEDED', 'position-11', '31401311@qq.com', '15196871611', 'address-11', 1),
  (12,  'name-12','login12', '25DBB8365K5K5KK71324K68093EEEDED', 'position-12', '31401312@qq.com', '15196871612', 'address-12', 4),
  (13,  'name-13','login13', '25DBB8365K5K5KK71324K68093EEEDED', 'position-13', '31401313@qq.com', '15196871613', 'address-13', 5),
  (14,  'name-14','login14', '25DBB8365K5K5KK71324K68093EEEDED', 'position-14', '31401314@qq.com', '15196871614', 'address-14', 1),
  (15,  'name-15','login15', '25DBB8365K5K5KK71324K68093EEEDED', 'position-15', '31401315@qq.com', '15196871615', 'address-15', 2),
  (16,  'name-16','login16', '25DBB8365K5K5KK71324K68093EEEDED', 'position-16', '31401316@qq.com', '15196871616', 'address-16', 3),
  (17,  'name-17','login17', '25DBB8365K5K5KK71324K68093EEEDED', 'position-17', '31401317@qq.com', '15196871617', 'address-17', 4),
  (18,  'name-18','login18', '25DBB8365K5K5KK71324K68093EEEDED', 'position-18', '31401318@qq.com', '15196871618', 'address-18', 7),
  (19,  'name-19','login19', '25DBB8365K5K5KK71324K68093EEEDED', 'position-19', '31401319@qq.com', '15196871619', 'address-19', 9),
  (20,  'name-20','login20', '25DBB8365K5K5KK71324K68093EEEDED', 'position-20', '31401320@qq.com', '15196871620', 'address-20', 1);
DELETE FROM `PersonObject`;
INSERT INTO PersonObject (personObjectId, month,personObjectName, personId)
VALUES
  (1, 2,'personObjectName-01', 1),
  (2, 2,'personObjectName-02', 3),
  (3, 4,'personObjectName-03', 9),
  (4, 4,'personObjectName-04', 1),
  (5, 5,'personObjectName-05', 2),
  (6, 8,'personObjectName-06', 6),
  (7, 9,'personObjectName-07', 4),
  (8, 6,'personObjectName-08', 8),
  (9, 9,'personObjectName-09', 9),
  (10,3,'personObjectName-10', 4),
  (11,7,'personObjectName-11', 1),
  (12,7,'personObjectName-12', 4),
  (13,8,'personObjectName-13', 5),
  (14,8,'personObjectName-14', 1),
  (15,9, 'personObjectName-15', 2),
  (16, 8,'personObjectName-16', 3),
  (17,9, 'personObjectName-17', 4),
  (18,8, 'personObjectName-18', 7),
  (19,7, 'personObjectName-19', 9),
  (20, 7,'personObjectName-20', 1);

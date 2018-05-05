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
INSERT INTO person (personId, personName, password, position, email, phone, address, departmentId)
VALUES
  (1, 'name-01', 'password-01', 'position-01', '31401301@qq.com', '1568716201', 'address-01', 1),
  (2, 'name-02', 'password-02', 'position-02', '31401302@qq.com', '1568716202', 'address-02', 3),
  (3, 'name-03', 'password-03', 'position-03', '31401303@qq.com', '1568716203', 'address-03', 9),
  (4, 'name-04', 'password-04', 'position-04', '31401304@qq.com', '1518716204', 'address-04', 1),
  (5, 'name-05', 'password-05', 'position-05', '31401305@qq.com', '1518716205', 'address-05', 2),
  (6, 'name-06', 'password-06', 'position-06', '31401306@qq.com', '1518716206', 'address-06', 6),
  (7, 'name-07', 'password-07', 'position-07', '31401307@qq.com', '1518716207', 'address-07', 4),
  (8, 'name-08', 'password-08', 'position-08', '31401308@qq.com', '1518716208', 'address-08', 8),
  (9, 'name-09', 'password-09', 'position-09', '31401309@qq.com', '1518716209', 'address-09', 9),
  (10, 'name-10', 'password-10', 'position-10', '31401310@qq.com', '1596871610', 'address-10', 4),
  (11, 'name-11', 'password-11', 'position-11', '31401311@qq.com', '1596871611', 'address-11', 1),
  (12, 'name-12', 'password-12', 'position-12', '31401312@qq.com', '1596871612', 'address-12', 4),
  (13, 'name-13', 'password-13', 'position-13', '31401313@qq.com', '1596871613', 'address-13', 5),
  (14, 'name-14', 'password-14', 'position-14', '31401314@qq.com', '1596871614', 'address-14', 1),
  (15, 'name-15', 'password-15', 'position-15', '31401315@qq.com', '1596871615', 'address-15', 2),
  (16, 'name-16', 'password-16', 'position-16', '31401316@qq.com', '1596871616', 'address-16', 3),
  (17, 'name-17', 'password-17', 'position-17', '31401317@qq.com', '1596871617', 'address-17', 4),
  (18, 'name-18', 'password-18', 'position-18', '31401318@qq.com', '1596871618', 'address-18', 7),
  (19, 'name-19', 'password-19', 'position-19', '31401319@qq.com', '1596871619', 'address-19', 9),
  (20, 'name-20', 'password-20', 'position-20', '31401320@qq.com', '1596871620', 'address-20', 1);
DELETE FROM `PersonObject`;
INSERT INTO PersonObject (personObjectId, personObjectName, personId)
VALUES
  (1, 'personObjectName-01', 1),
  (2, 'personObjectName-02', 3),
  (3, 'personObjectName-03', 9),
  (4, 'personObjectName-04', 1),
  (5, 'personObjectName-05', 2),
  (6, 'personObjectName-06', 6),
  (7, 'personObjectName-07', 4),
  (8, 'personObjectName-08', 8),
  (9, 'personObjectName-09', 9),
  (10, 'personObjectName-10', 4),
  (11, 'personObjectName-11', 1),
  (12, 'personObjectName-12', 4),
  (13, 'personObjectName-13', 5),
  (14, 'personObjectName-14', 1),
  (15, 'personObjectName-15', 2),
  (16, 'personObjectName-16', 3),
  (17, 'personObjectName-17', 4),
  (18, 'personObjectName-18', 7),
  (19, 'personObjectName-19', 9),
  (20, 'personObjectName-20', 1);

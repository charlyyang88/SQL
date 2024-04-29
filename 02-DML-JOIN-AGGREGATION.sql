--------------
-- JOIN
--------------

-- employees와 departments
DESC employees;
DESC departments;

SELECT * FROM employees; -- 107
SELECT * FROM departments; -- 27

SELECT * 
FROM employees, departments;
-- 카티젼 프로덕트

SELECT * 
FROM employees, departments
WHERE employees.department_id = departments.department_id; -- 106
-- INNER JOIN, EQUI-JOIN



-- alias를 이용한 원하는 필드의 Projection
-----------------------------
-- Simple Join or Equi-Join
-----------------------------

SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;   -- 106명, department_id가 null인 직원은 JOIN에서 배제

SELECT * FROM employees
WHERE department_id IS NULL;       -- 178 Kimberely

SELECT emp.first_name,
    dept.department_name
FROM employees emp JOIN departments dept USING (department_id);

-----------------------------
-- Theta Join
-----------------------------

-- Join 조건이 = 아닌 다른 조건들

-- 급여가 직군 평균 급여보다 낮은 직원들의 목록
SELECT 
    emp.employee_id,
    emp.first_name,
    emp.salary,
    emp.job_id,
    j.job_id,
    j.job_title
FROM employees emp JOIN jobs j ON emp.job_id = j.job_id
WHERE
    emp.salary < (j.min_salary + j.max_salary) / 2;

-----------------------------
-- OUTER JOIN
-----------------------------

-- 조건을 만족하는 짝이 없는 튜플도 NULL을 포함해서 결과 출력에 참여시키는 방법
-- 모든 결과를 표현한 테이블이 어느 쪽에 위치하는가에 따라서 LEFT, RIGHT, FULL OUTER JOIN으로 구분
-- ORACLE SQL의 경우 NULL이 출력되는 쪽에 (+)를 붙인다.

-----------------------------
-- LEFT OUTER JOIN
-----------------------------

-- Oracle SQL
SELECT emp.first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+);   -- null이 포함된 테이블 쪽에 (+) 표기

SELECT * FROM employees WHERE department_id IS NULL;


ANSI SQL - 명시적으로 JOIN 방법을 정한다
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp
    LEFT OUTER JOIN departments dept
        ON emp.department_id = dept.department_id;

-----------------------------
-- RIGHT OUTER JOIN
-----------------------------
-- RIGHT 테이블의 모든 레코드가 출력 결과에 참여

-- Oracle SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id;   --  departments 테이블 레코드 전부를 출력에 참여

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp 
    RIGHT OUTER JOIN departments dept
      ON emp.department_id = dept.department_id;

-----------------------------
-- FULL OUTER JOIN
-----------------------------

-- JOIN에 참여한 모든 테이블의 모든 레코드를 출력에 참여
-- 짝이 없는 레코드들은 null을 포함해서 출력에 참여

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp
    FULL OUTER JOIN departments dept
        ON emp.department_id = dept.department_id;

-----------------------------
-- NATURAL JOIN
-----------------------------

-- 조인할 테이블에 같은 이름의 컬럼이 있을 경우, 해당 컬럼을 기준으로 JOIN

SELECT * FROM employees emp NATURAL JOIN departments dept;

--SELECT * FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id;
--SELECT * FROM employees emp JOIN departments dept ON emp.manager_id = dept.manager_id;
SELECT * FROM employees emp JOIN departments dept ON emp.manager_id = dept.manager_id AND emp.department_id = dept.department_id;

-----------------------------
-- SELF JOIN
-----------------------------

-- 자기 자신과 JOIN
-- 자신을 두번 호출 -> 별칭을 반드시 부여해야 할 필요가 있는 JOIN

SELECT * FROM employees;    -- 107

SELECT 
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    mng.first_name
--FROM employees emp JOIN employees mng
--    ON emp.manager_id = mng.employee_id;
FROM employees emp, employees mng
WHERE emp.manager_id = mng.employee_id;     -- 106

-- Steven(매니저 없는 사원)까지 포함해서 출력
SELECT 
    emp.employee_id,
    emp.first_name,
    emp.manager_id,
    mng.first_name
FROM employees emp JOIN employees mng
    ON emp.manager_id = mng.employee_id (+);

-----------------------------
-- Group Aggregation
-----------------------------

-- 집계 : 여러 행으로부터 데이터를 수집, 하나의 행으로 반환

-- COUNT : 갯수 세기 함수
SELECT COUNT(*) FROM employees;

-- *로 카운트 하면 모든 해으이 수를 반환
-- 특정 컬럼 내에 null 값이 포함되어 있는지의 여부는 중요하지 않음

-- commission을 받는 직원의 수를 알고 싶을 경우
-- commission_pct 가 null인 경우를 제외하고 싶을 경우
SELECT COUNT(commission_pct) FROM employees;
-- 컬럼 내에 포함된 null 데이터를 카운트하지 않음

-- 위 쿼리는 아래 쿼리와 같다
SELECT COUNT(*) FROM employees
WHERE commission_pct IS NOT NULL;

-- SUM : 함계 함수
-- 모든 사원의 급여의 합계
SELECT SUM(salary) FROM employees;

-- AVG : 평균 함수
-- 사원들의 평균 급여
SELECT AVG(salary) FROM employees;

-- 사원들의 받는 평균 커미션 비율의 평균
SELECT AVG(commission_pct) FROM employees;
-- AVG 함수는 null 값이 포함되어 있을 경우 그 값을 집계 수치에서 제외
-- null 값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다
SELECT AVG(NVL(commission_pct, 0)) FROM employees;

-- min / max : 최소값 / 최대값
-- avg / median : 산술평균 / 중앙값
SELECT
    MIN(salary) 최소급여,
    MAX(salary) 최대급여,
    AVG(salary) 평균급여,
    MEDIAN(salary) 급여중앙값
FROM employees;

-- 흔히 범하는 오류
-- 부서별로 평균 급여를 구하고자 할 때
SELECT department_id, AVG(salary) 
FROM employees;

SELECT department_id FROM employees;    --   여러 개의 레코드
SELECT AVG(salary) FROM employees;      --  단일 레코드

SELECT department_id, salary
FROM employees
ORDER BY department_id;

SELECT department_id, ROUND (AVG(salary), 2) 
FROM employees
GROUP BY department_id
ORDER BY department_id;





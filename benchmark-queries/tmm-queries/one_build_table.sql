-- Table with 100M unique values for probing
-- CREATE TABLE probe AS
-- SELECT range i,
--        range j
-- FROM range(100000000);

-- -- Table with 90M unique values for building
-- CREATE TABLE build AS
-- SELECT i, j
-- FROM probe
-- WHERE i % 10 != 5;

-- -- Duplicate probe table to 400M
-- INSERT INTO probe
-- SELECT probe.*
-- FROM probe, range(3);


-- Building a JoinHashTable on the build table uses 90e6*(1+8+8+8+16)/1e9 = 3.7 GB
-- We set our memory limit to 5 GB so that only one hash table would fit

-- Now we join probe with 3x build
SELECT max(i),
       max(p.j),
       max(b1.j),
FROM probe AS p
JOIN build AS b1 USING (i);
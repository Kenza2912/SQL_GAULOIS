-- 1. Nom des lieux qui finissent par 'um'. 

SELECT nom_lieu
FROM lieu 
WHERE nom_lieu LIKE '%um';

-- 2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).

SELECT l.nom_lieu, COUNT(p.id_personnage) AS nbPersonnage
FROM lieu l
JOIN personnage p  ON  l.id_lieu = p.id_lieu
GROUP BY l.nom_lieu
ORDER BY nbPersonnage DESC;

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage. 
SELECT p.nom_personnage, s.nom_specialite, p.adresse_personnage, l.nom_lieu
FROM personnage p 
JOIN specialite s ON p.id_specialite = s.id_specialite
JOIN lieu l ON p.id_lieu = l.id_lieu
ORDER BY l.nom_lieu, p.nom_personnage;


-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant). 
SELECT s.nom_specialite, COUNT(p.id_personnage) AS nbPersonnage
FROM specialite s
LEFT JOIN personnage p ON s.id_specialite = p.id_specialite
GROUP BY s.nom_specialite
ORDER BY nbPersonnage DESC;

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).
SELECT b.nom_bataille, DATE_FORMAT(b.date_bataille,'%d/%m/%Y') AS dateBataille, l.nom_lieu
FROM bataille b
JOIN lieu l ON b.id_lieu= l.id_lieu
ORDER BY b.date_bataille DESC;

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant). 
SELECT p.nom_potion, SUM(i.cout_ingredient * c.qte) AS coutRealisation
FROM potion p
LEFT JOIN composer c ON p.id_potion = c.id_potion
LEFT JOIN ingredient i ON c.id_ingredient = i.id_ingredient
GROUP BY p.nom_potion
ORDER BY coutRealisation DESC;

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'. 

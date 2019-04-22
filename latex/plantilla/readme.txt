Para añadir los checklist al report:

1) Añade el paquete pdflscape en el preámbulo (\usepackage{pdflscape})
   
2) \input{checklist_###} al final (antes de \end{document}, claro)

Lo mejor es trabajar con la plantilla actualizada (iberonesia/latex). En todo caso, siempre se puede usar el método anterior


Para generar el fichero correspondiente: 

1) descarga el checklist (mejor en formato xls)
2) use read_checklists(filename,sheet), donde:  (matlab/calibration/tools)

	i ) filename=path absoluto al fichero
	ii) sheet=hoja correspondiente

Si todo va bien, la función te genera un fichero checklist_###.tex y te lo pone en latex/###




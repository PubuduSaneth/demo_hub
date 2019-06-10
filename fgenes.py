''' Find genes in given coordinates, coordinates of given genes or annotate intervals with cytoband notation

gencode_gene_search
  Usage: df['genes'] = df.apply(lambda x: gencode_gene_search(x[['chr', 'start', 'end']], tabix_file), axis=1)
  	  tabix_file: gencode_v19
 	  gencode_v19 = pysam.TabixFile('/Users/pubudu/Documents/RefData/Gencode/tabix_files/gencode.v19.annotation.gff3_all_known_genes.txt.sorted.formatted.txt.gz')
  Gencode.v19 source dataset descriptions:
          file:///Users/pubudu/Documents/RefData/Gencode/00.all_known_genes-gencode.v19.annotation.html
          file:///Users/pubudu/Documents/RefData/Gencode/00.protein_coding_known_genes-gencode.v19.annotation.html
  Returns: array with genes (and the overlap percentage)

fetch_gene_coords
  Usage: df['g_chr'], df['g_start'], df['g_end'] = zip(*df['gene_name'].apply(lambda x: fetch_gene_coords(x)))
  Returns: list containing chromosome, start and end of the gene "g"


cytoband_search
  Usage: cnv['cytoband'] = cnv.apply(lambda x: cytoband_search(x, tb), axis=1)
  Returns: Cytoband annotation
  tabix file: /Users/pubudu/Documents/RefData/hg19/cytoband/cytoBand.txt.sorted.txt.gz

'''

import pandas as pd

def overlap(q_st, q_end, res_st, res_end): #### Overlap base-pair calculation
    o  = min(q_end, res_end)-max(q_st, res_st)
    return o

def gencode_gene_search(a, tb, coverage=0):
    genes = []
    if "chr" in a['chr']:
        chrom = a['chr']
    else:
        chrom = "chr{}".format(a['chr'])
    try:
        for region in tb.fetch(chrom, int(a['start']), int(a['end'])):
            if region:
                r = region.split('\t')
                overlap_len = overlap(int(a['start']), int(a['end']), int(r[1]), int(r[2]))

                if coverage:
                    ret_val = '{}({})'.format(r[3], np.round(overlap_len/float(int(a['end'])-int(a['start']))*100, 2))
                    genes.append(ret_val)
                else:
                    genes.append(r[3])

        if len(genes)>0:
            return ";".join(genes)
        else:
            return "NA"

    except ValueError:
        return "NA"

gencode = pd.read_table("/Users/pubudu/Documents/RefData/Gencode/gencode.v19.annotation.gff3_all_known_genes.txt.sorted.formatted.txt", sep = "\t", names = ['chr', 'start', 'end', 'gene_name'])
gencode = gencode.set_index('gene_name')

def fetch_gene_coords(g):

    if gencode.index.contains(g): #.loc[g]:
        #if len(gencode_genes.loc[g]['seqname'])>1:
            #print (gencode_genes.loc[g]['seqname'], len(gencode_genes.loc[g]['seqname']))
        return gencode.loc[g]['chr'], gencode.loc[g]['start'], gencode.loc[g]['end']  #gencode_genes.loc[g][['seqname', 'start', 'end']]
    else:
        #print ("{}: Not found".format(g))
        return "NA", "NA", "NA"


def cytoband_search(r, tb, add_chr=True):
    c_band = []

    if add_chr:
        chromosome = "chr{}".format(r['chr'])
    else:
        chromosome = r['chr']

    try:
        for region in tb.fetch(chromosome, int(r['start']), int(r['end'])):
            if region:
                c = region.split('\t')
                c_band.append(c[3])
        if len(c_band)>1:
            if c_band[0][0] == c_band[-1][0]:
                return ("{}{}-{}".format(r['chr'], c_band[0], c_band[-1][1:]))
            else:
                return ("{}{}-{}".format(r['chr'], c_band[0], c_band[-1]))
        else:
            return "{}{}".format(r['chr'], c_band[0])
    except ValueError:
        return "NA"

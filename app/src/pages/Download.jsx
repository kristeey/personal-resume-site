import React, {useState} from 'react';
import { PDFDownloadLink, StyleSheet, Document, Page, View, Text } from '@react-pdf/renderer';


const styles = StyleSheet.create({
  page: { backgroundColor: 'tomato' },
  section: { color: 'white', textAlign: 'center', margin: 30 },
})


const MyCV = () => {
  return (
    <Document>
      <Page size="A4" style={styles.page}>
        <View style={styles.section}>
          <Text>Hello World</Text>
        </View>
      </Page>
    </Document>
  )
};

const PdfDownloadButton = () => {
  const [pdfUrl, setPdfUrl] = useState(null);
  return (
    <div>
      <PDFDownloadLink 
        document={<MyCV/>}
        fileName='resume'
        onClick={(url) => setPdfUrl(url)}
        style={{ border: 'none'}}
      >
        {({blob, url, loading, error}) => (
          <div className="button">
            {loading ? 'Loading document...' : 'Download'}
          </div>
        )}
      </PDFDownloadLink>
    </div>
  )
}


export default PdfDownloadButton

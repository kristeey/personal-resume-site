import React, {useState} from 'react';
import { PDFDownloadLink } from '@react-pdf/renderer';
import ResumePdf from '../ResumePdf/ResumePdf';

const DownloadButton = () => {
  const [pdfUrl, setPdfUrl] = useState(null);
  return (
    <div>
      <PDFDownloadLink 
        document={<ResumePdf />}
        fileName="cv"
        onClick={(url) => setPdfUrl(url)}
        style={{ border: 'none'}}
      >
        {({blob, url, loading, error}) => (
          <div className="button">
            {loading ? 'Loading Resume...' : 'Download Resume'}
          </div>
        )}
      </PDFDownloadLink>
    </div>
  )
}

export default DownloadButton;
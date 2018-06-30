<?php

namespace App\Controller;

use App\Service\ParkResolver;
use Knp\Bundle\SnappyBundle\Snappy\Response\PdfResponse;
use Knp\Snappy\Pdf;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Class DefaultController.
 */
class DefaultController extends Controller
{
    /**
     * @param Pdf $knpPdf
     * @param Request $request
     * @return Response
     */
    public function print(Pdf $knpPdf, Request $request): Response
    {
        $html = $request->get('html', false);
        $url = $request->get('url', false);
        $filename = $request->get('filename', 'output.pdf');
        $options = $request->get('options', []);
        $knpPdf->setOptions($options);
        $knpPdf->setOption('cache-dir', '/tmp/wkhtml');
        $disposition = $request->get('disposition', 'attachment');

        if($html !== false){
            $output = $knpPdf->getOutputFromHtml($html);
        } elseif($url !== false) {
            $output = $knpPdf->getOutput(is_array($url) ? $url : [$url]);
        } else {
            $output = $knpPdf->getOutputFromHtml("You should provide html or url parameter to draw a complete html.");
        }

        return new PdfResponse($output, $filename, 'application/pdf', $disposition);
    }
}

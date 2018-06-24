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
        $html = $request->get('html', null);
        $filename = $request->get('filename', 'output.pdf');
        $options = $request->get('options', []);
        $knpPdf->setOptions($options);
        $disposition = $request->get('disposition', 'attachment');

        return new PdfResponse(
            $knpPdf->getOutputFromHtml($html),
            $filename,
            'application/pdf',
            $disposition
        );
    }
}
